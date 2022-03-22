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
    @streaming_service_account = streaming_service.streaming_service_account

    @live_stream = StreamingService::ShowVideoService.new(@streaming_service_account, video_id: params[:id]).execute
  rescue StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError
    render plain: "リクエストのリミットに達しました。時間を空けて再度試してください。"
  rescue StreamingService::YoutubeLiveClient::VideoNotFoundError
    render plain: "動画が存在しませんでした"
  end

  def update_chat_page_token_as_read
  end

  def chat_messages
  end
end
