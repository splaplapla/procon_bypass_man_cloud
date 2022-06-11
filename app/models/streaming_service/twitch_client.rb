# https://dev.twitch.tv/docs/authentication/refresh-tokens

class StreamingService::TwitchClient
  BASE = "https://api.twitch.tv/helix"
  CLIENT_ID = ENV["TWITCH_CLIENT_ID"]

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  def myself_live
    uri = URI.parse("#{BASE}/streams")
    uri.query = "user_login=fps_shaka"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    req["Client-Id"] = CLIENT_ID
    Rails.logger.info { "[twitch api] #{uri.to_s}" }
    http.request(req)
  end


  def s
    uri = URI.parse("#{BASE}/search/channels")
    uri.query = "query=jiikko28'"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    req["Client-Id"] = CLIENT_ID
    Rails.logger.info { "[twitch api] #{uri.to_s}" }
    http.request(req)
  end

  def myself
    uri = URI.parse("#{BASE}/users")
    uri.query = ""

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{access_token}"
    req["Client-Id"] = CLIENT_ID
    Rails.logger.info { "[twitch api] #{uri.to_s}" }
    http.request(req)
  end

  def access_token
    @streaming_service_account.access_token
  end
end
