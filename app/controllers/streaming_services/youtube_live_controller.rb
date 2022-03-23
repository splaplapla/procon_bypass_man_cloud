class StreamingServices::YoutubeLiveController < ApplicationController
  before_action :reject_when_not_monitoring, only: [:commands]

  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @my_channel_id, @live_stream = StreamingService::ShowAvailableLiveStreamService.new(@streaming_service_account).execute
  rescue StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError
    render text: "リクエストのリミットに達しました。時間を空けて再度試してください。", status: :server_error
  end

  def show
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @live_stream = StreamingService::ShowLiveStreamService.new(@streaming_service_account, video_id: params[:id]).execute
  rescue StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError
    render plain: "リクエストのリミットに達しました。時間を空けて再度試してください。", status: :server_error
  rescue StreamingService::YoutubeLiveClient::VideoNotFoundError
    render plain: "動画が存在しませんでした", status: :not_found
  rescue StreamingService::YoutubeLiveClient::NotLiveStreamError
    render plain: "ライブ配信ではありません", status: :not_found
  end

  def commands
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    messages = StreamingService::FetchChatMessagesService.new(@streaming_service_account, video_id: params[:id]).execute
    result = StreamingService::ConvertMessagesToCommandsService.new(@streaming_service_account, messages: messages).execute
    render json: { commands: result, all: messages }
  rescue StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError
    render plain: "リクエストのリミットに達しました。時間を空けて再度試してください。", status: :server_error
  rescue StreamingService::YoutubeLiveClient::LiveChatRateLimitError
    render json: { errors: ["メッセージの取得頻度が早すぎます。"] }, status: :bad_request
  end

  private

  def reject_when_not_monitoring
    if streaming_service_account.monitors_at.nil?
      return head :bad_request
    end
  end

  def streaming_service
    @streaming_service ||= current_user.streaming_services.find(params[:streaming_service_id])
  end

  def streaming_service_account
    @streaming_service_account ||= streaming_service.streaming_service_account
  end
end
