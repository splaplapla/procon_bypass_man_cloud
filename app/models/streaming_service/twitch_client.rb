# TODO https://dev.twitch.tv/docs/authentication/refresh-tokens

class StreamingService::TwitchClient
  BASE = "https://api.twitch.tv/helix"
  CLIENT_ID = ENV["TWITCH_CLIENT_ID"]

  class BaseRequest
    def self.do_request(uri: )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      req["Authorization"] = "Bearer #{@access_token}"
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

    private
  end

  class GetMyselfRequest < BaseRequest
    def execute
      uri = URI.parse("#{BASE}/users")
      self.class.do_request(uri: uri)
    end
  end

  class TwitchUser < Struct.new(:id, :login, :display_name, :type, :broadcaster_type, :email); end
  class GetMyselfLive < BaseRequest
    def execute
      uri = URI.parse("#{BASE}/streams")
      uri.query = "user_login=fps_shaka"
      response = self.class.do_request(uri: uri)
    end
  end

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  def myself_live
    raw_response = GetMyselfLiveRequest.new(access_token: access_token).execute
  end

  def myself
    raw_response = GetMyselfRequest.new(access_token: access_token).execute
    json = JSON.parse(raw_response.body)
    TwitchUser.new(*json['data'].first.slice('id', 'login', 'display_name', 'type', 'broadcaster_type', 'email').values)
  end

  def access_token
    @streaming_service_account.access_token
  end
end
