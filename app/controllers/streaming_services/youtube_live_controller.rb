class StreamingServices::YoutubeLiveController < ApplicationController
  class YoutubeLiveDecorator
    def initialize(streaming_service_account)
      @streaming_service_account = streaming_service_account
    end

    def my_channel_id
      @streaming_service_account.cached_data["my_channel_id"]
    end

    def method_missing(name, *arg)
      @streaming_service_account.send(name, *arg)
    end
  end

  def new
    @streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    @streaming_service_account = @streaming_service.streaming_service_account

    decorated_streaming_service_account = YoutubeLiveDecorator.new(@streaming_service_account)
    client = StreamingService::YoutubeLiveClient.new(decorated_streaming_service_account)
    if @streaming_service_account.cached_data["my_channel_id"].blank?
      @streaming_service_account.cached_data["my_channel_id"] = client.my_channel_id
      @streaming_service_account.save!
    end
    @my_channel_id = decorated_streaming_service_account.my_channel_id
    @live_stream = client.live_stream
  end

  def show
    streaming_service = current_user.streaming_services.find(params[:streaming_service_id])
    video_id = params[:id]
  end
end
