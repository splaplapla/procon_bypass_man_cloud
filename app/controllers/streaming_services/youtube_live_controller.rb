class StreamingServices::YoutubeLiveController < ApplicationController
  def new
    streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    @streaming_service_account = streaming_service.streaming_service_account
    client = StreamingService::YoutubeLiveClient.new(@streaming_service_account)
    @live_stream = client.live_stream
  rescue StreamingService::YoutubeLiveClient::OutdatedRefreshTokenError
    redirect outdated_refresh_token_streaming_service_path(params[:streaming_service_id])
  end
end
