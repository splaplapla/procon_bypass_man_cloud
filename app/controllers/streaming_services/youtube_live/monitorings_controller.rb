class StreamingServices::YoutubeLive::MonitoringsController < StreamingServices::Base
  def create
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @streaming_service_account.start_monitoring
    redirect_to streaming_service_youtube_live_path(@streaming_service, params[:youtube_live_id]), notice: "コメントとの連携を開始しました。"
  end

  def destroy
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @streaming_service_account.stop_monitoring
    redirect_to streaming_service_youtube_live_path(@streaming_service, params[:youtube_live_id]), notice: "コメントとの連携を停止しました。"
  end
end
