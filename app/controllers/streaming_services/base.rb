class StreamingServices::Base < ApplicationController

  rescue_from StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError, with: :render_exceeded_youtube_quota_error
  rescue_from StreamingService::YoutubeLiveClient::LiveChatRateLimitError, with: :render_live_chat_rate_limit_error

  private

  def streaming_service
    @streaming_service ||= current_user.streaming_services.find(params[:streaming_service_id])
  end

  def streaming_service_account
    @streaming_service_account ||= streaming_service.streaming_service_account
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
