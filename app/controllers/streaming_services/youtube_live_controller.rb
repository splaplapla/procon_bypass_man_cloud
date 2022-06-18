class StreamingServices::YoutubeLiveController < StreamingServices::Base
  rescue_from StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError, with: :render_exceeded_youtube_quota_error
  rescue_from StreamingService::YoutubeLiveClient::LiveChatRateLimitError, with: :render_live_chat_rate_limit_error

  before_action :reject_when_not_monitoring, only: [:commands]

  skip_forgery_protection only: [:commands]

  def new
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @my_channel_id, @live_stream = StreamingService::ShowAvailableLiveStreamService.new(@streaming_service_account).execute
  end

  def show
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    @live_stream = StreamingService::ShowLiveStreamService.new(@streaming_service_account, video_id: params[:id]).execute
  rescue StreamingService::ShowLiveStreamService::AvailableVideoNotError => e
    @streaming_service_account.stop_monitoring
    render plain: e.message, status: :not_found
  end

  def commands
    @streaming_service = streaming_service
    @streaming_service_account = streaming_service_account
    messages = StreamingService::FetchChatMessagesService.new(@streaming_service_account, video_id: params[:id]).execute
    result = StreamingService::ConvertMessagesToCommandsService.new(@streaming_service_account, messages: messages).execute
    render json: { commands: result, all: messages }
  end

  private

  def reject_when_not_monitoring
    if streaming_service_account.monitors_at.nil?
      return head :bad_request
    end
  end

  def render_exceeded_youtube_quota_error
    Rails.logger.error "youtube APIのレートリミットに達しました。時間を空けて再度試してください。"
    render json: { errors: ["youtube APIのレートリミットに達しました。時間を空けて再度試してください。"] }, status: :internal_server_error
  end

  def render_live_chat_rate_limit_error
    Rails.logger.error "メッセージの取得頻度が早すぎます。"
    render json: { errors: ["メッセージの取得頻度が早すぎます。"] }, status: :bad_request
  end
end
