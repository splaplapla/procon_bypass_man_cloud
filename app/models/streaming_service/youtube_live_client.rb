class StreamingService::YoutubeLiveClient
  BASE = "https://www.googleapis.com/youtube"

  class UnexpectedError < StandardError; end
  class ExceededYoutubeQuotaError < StandardError; end
  class LiveChatRateLimitError < StandardError; end
  class OldAccessTokenError < StandardError; end
  class VideoNotFoundError < StandardError; end
  class NotOwnerVideoError < StandardError; end
  class NotLiveStreamError < StandardError; end

  class BaseRequest
    def self.request(uri: )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      yield(req)
      Rails.logger.debug { "[youtube api] #{uri.to_s}" }
      http.request(req)
    end
  end

  class LiveStreamDetailRequest < BaseRequest
    def self.request(video_id: , access_token: )
      uri = URI.parse("#{BASE}/v3/videos")
      uri.query = "id=#{video_id}&part=snippet,liveStreamingDetails&maxResults=2"
      super(uri: uri) do |req|
        req["Authorization"] = "Bearer #{access_token}"
      end
    end
  end

  class AvailableLiveStreamRequest < BaseRequest
    def self.request(my_channel_id: , access_token: )
      uri = URI.parse("#{BASE}/v3/search")
      uri.query = "channelId=#{my_channel_id}&part=id,snippet&type=video&eventType=live&maxResults=2"
      super(uri: uri) do |req|
        req["Authorization"] = "Bearer #{access_token}"
      end
    end
  end

  class ChatMessagesRequest < BaseRequest
    def self.request(video_id: , chat_id: , page_token: , access_token: )
      uri = URI.parse("#{BASE}/v3/liveChat/messages")
      uri.query = "id=#{video_id}&liveChatId=#{chat_id}&part=id,snippet,authorDetails&pageToken=#{page_token}"
      super(uri: uri) do |req|
        req["Authorization"] = "Bearer #{access_token}"
      end
    end
  end

  attr_accessor :video_id, :chat_id
  attr_writer :my_channel_id

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  class Message < Struct.new(:body, :author_channel_id, :author_name, :owner, :moderator, :published_at); end

  def chat_messages(page_token: nil)
    raw = raw_chat_messages(page_token: page_token)
    page_token = raw["nextPageToken"]
    messages = raw["items"].map do |item|
      Message.new(
        item.dig("snippet", "textMessageDetails", "messageText"),
        item.dig("snippet", "authorChannelId"),
        item.dig("authorDetails", "displayName"),
        item.dig("authorDetails", "isChatOwner"),
        item.dig("authorDetails", "isChatModerator"),
        item.dig("snippet", "publishedAt").to_time.in_time_zone('Asia/Tokyo'),
      )
    end
    return [page_token, messages]
  end

  # @raise [LiveChatRateLimitError]
  # @return [Array<String>, NilClass]
  def raw_chat_messages(page_token: nil)
    raise "need chat_id" if chat_id.nil?
    raise "need video_id" if video_id.nil?

    response = ChatMessagesRequest.request(video_id: video_id, chat_id: chat_id, page_token: page_token, access_token: access_token)
    handle_error(response) do |json|
      return json
    end
  rescue OldAccessTokenError
    retry
  end

  # @return [String, NilClass]
  def chat_id
    return @chat_id if defined?(@chat_id) && @chat_id
    raise "active_streaming_videoで取得したchat_idを使ってください"
  end

  # @return [Video, NilClass]
  # @raise [NotLiveStreamError] chat_idがない場合は配信中ではないと判断する
  # @raise [NotOwnerVideoError] 別チャンネルの配信のとき
  # @raise [VideoNotFoundError] video_idに一致するvideoが返ってこないとき
  # video_idを使ってchat_idを含むVideoを返す. chat_idがない場合は配信中ではないと判断してエラーを返す
  def active_streaming_video
    raise "need video_id" if video_id.nil?

    response = LiveStreamDetailRequest.request(video_id: video_id, access_token: access_token)
    handle_error(response) do |json|
      if(item = json["items"].first)
        chat_id = item.dig("liveStreamingDetails", "activeLiveChatId") or raise(NotLiveStreamError, "Could not find a chat_id")
        if(channel_id = item.dig("snippet", "channelId")) && my_channel_id != channel_id && !Rails.env.development?
          raise NotOwnerVideoError, "This video is Not Owner. Check the video id."
        end

        return StreamingService::YoutubeLive::Video.new(
          item.dig("id"),
          item.dig("snippet", "publishedAt").to_time.in_time_zone('Asia/Tokyo').to_s,
          item.dig("snippet", "title"),
          item.dig("snippet", "description"),
          item.dig("snippet", "thumbnails", "high", "url"),
          chat_id,
        )
      else
        raise VideoNotFoundError, "Check the video_id"
      end
    end
  rescue OldAccessTokenError
    retry
  end

  # @return [Video, NilClass]
  # 公開しているライブ配信のみを返す. 限定公開だと返ってこない. chat_idはない
  def available_live_stream
    response = AvailableLiveStreamRequest.request(my_channel_id: my_channel_id, access_token: access_token)
    handle_error(response) do |json|
      if(item = json["items"].first)
        return StreamingService::YoutubeLive::Video.new(
          item.dig("id", "videoId"),
          item.dig("snippet", "publishedAt").to_time.in_time_zone('Asia/Tokyo').to_s,
          item.dig("snippet", "title"),
          item.dig("snippet", "description"),
          item.dig("snippet", "thumbnails", "high", "url"),
        )
      end
    end
  rescue OldAccessTokenError
    retry
  end

  def refresh!
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
    Rails.logger.debug { "[youtube api] #{uri.to_s}" }
    response = http.post(uri.path, params.to_json, headers)

    handle_error(response) do |json|
      @streaming_service_account.update!(
        access_token: json['access_token'],
        expires_at: Time.zone.now + json['expires_in'],
      )
    end
  end

  # @return [String]
  def my_channel_id
    if @streaming_service_account.respond_to?(:my_channel_id) && @streaming_service_account.my_channel_id.present?
      return @streaming_service_account.my_channel_id
    end
    return @my_channel_id if defined?(@my_channel_id)

    uri = URI.parse("#{BASE}/v3/channels")
    uri.query = "mine=true&part=contentDetails"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    Rails.logger.debug { "[youtube api] #{uri.to_s}" }
    res = http.request(req)

    handle_error(res) do |json|
      @my_channel_id = json["items"].first["id"]
      return @my_channel_id
    end
  rescue OldAccessTokenError
    retry
  end

  private

  # @raise [OldAccessTokenError] access_tokenを作成し直したら投げる
  def handle_error(response, &block)
    if response.code == "200"
      block.call(
        JSON.parse(response.body)
      )
    elsif response.code == "401"
      refresh!
      raise OldAccessTokenError
    elsif response.code == "403"
      errors = parse_error(response.body)

      case
      when errors.include?("youtube.quota")
        raise ExceededYoutubeQuotaError
      when errors.include?("youtube.liveChat")
        raise LiveChatRateLimitError
      else
        raise "知らないエラーです(#{response.body})"
      end
    else
      raise UnexpectedError, JSON.parse(response.body)
    end
  end

  # @return [String]
  def access_token
    @streaming_service_account.access_token
  end

  # "domain": "youtube.liveChat", "reason": "rateLimitExceeded"
  # TODO reasonもとる
  def parse_error(body)
    return JSON.parse(body).dig("error", "errors").map {|x| x["domain"] }
  end
end
