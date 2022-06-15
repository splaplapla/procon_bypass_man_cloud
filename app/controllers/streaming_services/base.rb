class StreamingServices::Base < ApplicationController

  private

  def streaming_service
    @streaming_service ||= current_user.streaming_services.find(params[:streaming_service_id])
  end

  def streaming_service_account
    @streaming_service_account ||= streaming_service.streaming_service_account
  end
end
