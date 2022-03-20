class StreamingService::YoutubeLiveClient
  BASE = "https://www.googleapis.com/youtube"

  class UnexpectedError < StandardError; end
  class ExceededYoutubeQuotaError < StandardError; end

  class Video < Struct.new(:id, :published_at, :title, :description, :thumbnails_high); end
  class LiveStreamRequest
    def self.request(my_channel_id: , access_token: )
      uri = URI.parse("#{BASE}/v3/search")
      uri.query = "channelId=#{my_channel_id}&part=id,snippet&type=video&eventType=live&maxResults=2"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      req["Authorization"] = "Bearer #{access_token}"
      http.request(req)
    end
  end

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  # @return [Array<String>, NilClass]
  def get_chat_messages(pageToken: nil)
    return nil unless chat_id_of_live_stream

    raw = get_raw_chat_messages(pageToken: pageToken)
    pageToken = raw["nextPageToken"]
    messages = raw["items"].map do |item|
      item.dig("snippet", "textMessageDetails", "messageText")
    end
    return [pageToken, messages]
  end

  # @return [Array<String>, NilClass]
  def get_raw_chat_messages(pageToken: nil)
    return nil unless chat_id_of_live_stream

    uri = URI.parse("#{BASE}/v3/liveChat/messages")
    uri.query = "id=#{live_stream_id}&liveChatId=#{chat_id_of_live_stream}&part=id,snippet,authorDetails&pageToken=#{pageToken}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    res = http.request(req)
    if res.code == '200'
      return json = JSON.parse(res.body)
    else
      Rails.logger.error "get_chat_messagesをcallしたら#{response.code}が帰ってきました。"
    end
  end

  # @return [String, NilClass]
  def chat_id_of_live_stream
    return nil unless live_stream_id

    uri = URI.parse("#{BASE}/v3/videos")
    uri.query = "id=#{live_stream_id}&part=liveStreamingDetails"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    res = http.request(req)
    if res.code == '200'
      json = JSON.parse(res.body)
      if(item = json["items"].first)
        return item.dig("liveStreamingDetails", "activeLiveChatId")
      end

      return nil
    else
      Rails.logger.error "chat_id_of_live_streamをcallしたら#{response.code}が帰ってきました。"
    end
  end

  # @return [String, NilClass]
  def live_stream_id
    live_stream&.id
  end

  # @return [Video, NilClass]
  def live_stream
    response = LiveStreamRequest.request(my_channel_id: my_channel_id, access_token: access_token)
    if response.code == '200'
      json = JSON.parse(response.body)
      if(item = json["items"].first)
        return Video.new(
          item.dig("id", "videoId"),
          item.dig("snippet", "publishedAt").to_time.in_time_zone('Asia/Tokyo') ,
          item.dig("snippet", "title"),
          item.dig("snippet", "description"),
          item.dig("snippet", "thumbnails", "high"),
        )
      end

      return nil
    else
      Rails.logger.error "live_streamをcallしたら#{response.code}が帰ってきました。(#{response.body})"
      return nil
    end
  end

  def refresh
    uri = URI.parse("https://accounts.google.com/o/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"
    params = {
      client_id: ENV.fetch('GOOGLE_OAUTH2_CLIENT_ID'),
      client_secret: ENV.fetch('GOOGLE_OAUTH2_SECRET'),
      refresh_token: @streaming_service_account.refresh_token,
      grant_type: 'refresh_token',
    }
    headers = { 'Content-Type' => 'application/json' }
    response = http.post(uri.path, params.to_json, headers)

    if response.code == '200'
      json = JSON.parse(response.body)
      @streaming_service_account.update!(
        access_token: json['access_token'],
        expires_at: Time.zone.now + json['expires_in'],
      )
    else
      Rails.logger.error "refreshをしたら#{response.code}が帰ってきました。"
    end
  end

  # @return [String]
  def my_channel_id
    return @my_channel_id if defined?(@my_channel_id)

    uri = URI.parse("#{BASE}/v3/channels")
    uri.query = "mine=true&part=contentDetails"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    res = http.request(req)

    if res.code == "200"
      @my_channel_id = JSON.parse(res.body)["items"].first["id"]
      return @my_channel_id
    elsif res.code == "401"
      refresh
      return my_channel_id
    elsif res.code == "403"
      errors = parse_error(res.body)
      case
      when errors.include?("youtube.quota")
        raise ExceededYoutubeQuotaError
      else
        raise "知らないエラーです(#{res.body})"
      end
    else
      raise UnexpectedError
    end
  end

  private

  # @return [String]
  def access_token
    @streaming_service_account.access_token
  end

  def parse_error(body)
    return JSON.parse(body).dig("error", "errors").map {|x| x["domain"] }
  end
end
