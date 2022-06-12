class StreamingServices::TwitchController < StreamingServices::Base
  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
  end

  def show
  end
end
