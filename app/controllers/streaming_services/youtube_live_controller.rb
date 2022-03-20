class StreamingServices::YoutubeLiveController < ApplicationController
  def new
    @streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    @streaming_service_account = @streaming_service.streaming_service_account

    @my_channel_id, @live_stream = StreamingService::ShowLiveStreamService.new(@streaming_service_account).execute
  rescue StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError
    render text: "リクエストのリミットに達しました。時間を空けて再度試してください。"
  end

  def show
    streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    video_id = params[:id]
  end
end
