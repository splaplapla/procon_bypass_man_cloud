class StreamingServices::TwitchController < StreamingServices::Base
  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @live_stream = StreamingService::TwitchClient.new(@streaming_service_account).myself_live
  end

  def show
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    client = StreamingService::TwitchClient.new(@streaming_service_account)
    @live_stream = client.myself_live
    @twitch_my_user = client.myself
  end
end
