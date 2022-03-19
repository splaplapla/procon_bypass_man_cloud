class StreamingServicesController < ApplicationController
  def index
    @streaming_services = current_user.streaming_services
  end

  def new
    @streaming_service = current_user.streaming_services.build
  end

  def create
  end
end
