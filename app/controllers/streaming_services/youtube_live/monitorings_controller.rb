class StreamingServices::YoutubeLive::MonitoringsController < StreamingServices::Base
  def create
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @streaming_service_account.start_monitoring
    redirect_to streaming_service_youtube_live_path(@streaming_service, params[:youtube_live_id])
  end

  def destroy
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @streaming_service_account.stop_monitoring
    redirect_to streaming_service_youtube_live_path(@streaming_service, params[:youtube_live_id])
  end
end
