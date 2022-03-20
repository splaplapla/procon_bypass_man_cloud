class StreamingServices::YoutubeLiveController < ApplicationController
  def new
    @streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    @streaming_service_account = @streaming_service.streaming_service_account
    client = StreamingService::YoutubeLiveClient.new(@streaming_service_account)
    @live_stream = client.live_stream
    @my_channel_id = client.my_channel_id
  end

  def show
    streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    video_id = params[:id]
  end
end
