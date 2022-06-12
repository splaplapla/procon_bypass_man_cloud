class StreamingService::TwitchClient
  class UnexpectedError < StandardError; end
  class OldAccessTokenError < StandardError; end

  class Live < Struct.new(:id, :user_id, :user_name, :user_login, :type, :title, :thumbnail_url, :started_at)
    def started_at
      super.to_time
    end

    def thumbnail_url
      super.gsub('{width}x{height}', 'x')
    end
  end
  class TwitchUser < Struct.new(:id, :login, :display_name, :type, :broadcaster_type, :email); end

  BASE = "https://api.twitch.tv/helix"
  CLIENT_ID = ENV["TWITCH_OAUTH2_CLIENT_ID"]

  class BaseRequest
    attr_reader :access_token

    def self.do_request(uri: , access_token: )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      req["Authorization"] = "Bearer #{access_token}"
      req["Client-Id"] = CLIENT_ID
      Rails.logger.info { "[twitch api] #{uri.to_s}" }
      http.request(req)
    end

    def initialize(access_token: )
      @access_token = access_token
    end

    def execute
      raise NoImplimentError
    end
  end

  class GetMyselfLiveRequest < BaseRequest
    def execute(user_name: )
      uri = URI.parse("#{BASE}/streams")
      uri.query = "user_login=#{user_name}"
       self.class.do_request(uri: uri, access_token: access_token)
    end
  end

  class GetMyselfRequest < BaseRequest
    def execute
      uri = URI.parse("#{BASE}/users")
      self.class.do_request(uri: uri, access_token: access_token)
    end
  end

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  def myself_live
    response = GetMyselfLiveRequest.new(access_token: access_token).execute(user_name: 'rinadecoro') # TODO myself.loginにする
    return handle_error(response) do |json|
      break nil if json['data'].empty?
      Live.new(*json['data'].first.slice('id', 'user_id', 'user_name', 'user_login', 'type', 'title', 'thumbnail_url', 'started_at').values)
    end
  rescue OldAccessTokenError
    retry
  end

  def myself
    return @myself if defined?(@myself)

    response = GetMyselfRequest.new(access_token: access_token).execute
    handle_error(response) do |json|
      @myself = TwitchUser.new(*json['data'].first.slice('id', 'login', 'display_name', 'type', 'broadcaster_type', 'email').values)
    end
  rescue OldAccessTokenError
    retry
  end

  private

  def access_token
    @streaming_service_account.access_token
  end

  def handle_error(response, &block)
    if response.code == "200"
      return block.call(JSON.parse(response.body))
    elsif response.code == "401"
      refresh!
      raise OldAccessTokenError
    elsif response.code == "403"
      errors = parse_error(response.body)
      case
      when nil
      else
        raise "知らないエラーです(#{response.body})"
      end
    else
      raise UnexpectedError, JSON.parse(response.body)
    end
  end

  def parse_error(body)
    JSON.parse(body).dig("error", "errors").map {|x| x["domain"] }
  end

  # @return [void]
  def refresh!
    uri = URI.parse("https://id.twitch.tv/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme === "https"
    params = {
      client_id: ENV.fetch('TWITCH_OAUTH2_CLIENT_ID'),
      client_secret: ENV.fetch('TWITCH_OAUTH2_SECRET'),
      refresh_token: @streaming_service_account.refresh_token,
      grant_type: 'refresh_token',
    }
    headers = { 'Content-Type' => 'application/json' }
    Rails.logger.info { "[twitch] #{uri.to_s}" }
    response = http.post(uri.path, params.to_json, headers)

    handle_error(response) do |json|
      @streaming_service_account.update!(
        access_token: json['access_token'],
        expires_at: Time.zone.now + json['expires_in'],
      )
    end
  end
end
