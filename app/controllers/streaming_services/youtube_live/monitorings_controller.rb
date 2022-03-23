class StreamingServices::YoutubeLive::MonitoringsController < ApplicationController
  def create
    @streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    @streaming_service_account = @streaming_service.streaming_service_account
    @streaming_service_account.update!(monitors_at: Time.zone.now)
    head :ok
  end

  def destroy
    @streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    @streaming_service_account = @streaming_service.streaming_service_account
    @streaming_service_account.update!(monitors_at: nil)
    head :ok
  end
end
