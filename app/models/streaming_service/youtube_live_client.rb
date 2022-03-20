class StreamingService::YoutubeLiveClient
  class Video < Struct.new(:id, :published_at, :title, :description, :thumbnails_high); end

  class UnexpectedError < StandardError; end

  BASE = "https://www.googleapis.com/youtube"

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  # @return [Video, NilClass]
  def live_stream
    uri = URI.parse("#{BASE}/v3/search")
    uri.query = "channelId=#{my_channel_id}&part=id,snippet&type=video&eventType=live&maxResults=2"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    res = http.request(req)

    if response.code == '200'
      json = JSON.parse(res.body)

      if(item = json["items"].first)
        return Video.new(
          item.dig("id", "videoId"),
          item.dig("snippet", "publishedAt").to_time,
          item.dig("snippet", "title"),
          item.dig("snippet", "description"),
          item.dig("snippet", "thumbnails", "high"),
        )
      end

      return nil
    else
      Rails.logger.error "live_streamをcallしたら#{response.code}が帰ってきました。"
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

  private

  # @return [String]
  def access_token
    @streaming_service_account.access_token
  end

  # @return [String]
  def my_channel_id
    uri = URI.parse("#{BASE}/v3/channels")
    uri.query = "mine=true&part=contentDetails"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    res = http.request(req)
    if res.code.to_s == "200"
      return JSON.parse(res.body)["items"].first["id"]
    else
      raise UnexpectedError
    end
  end
end
