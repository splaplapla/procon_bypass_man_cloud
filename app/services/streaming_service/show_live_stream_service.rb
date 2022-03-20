class StreamingService::ShowLiveStreamService
  class YoutubeLiveDecorator
    def initialize(streaming_service_account)
      @streaming_service_account = streaming_service_account
    end

    def my_channel_id
      @streaming_service_account.cached_data["my_channel_id"]
    end

    private

    def method_missing(name, *arg)
      @streaming_service_account.send(name, *arg)
    end
  end

  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  def execute
    decorated_streaming_service_account = YoutubeLiveDecorator.new(@streaming_service_account)

    client = StreamingService::YoutubeLiveClient.new(decorated_streaming_service_account)
    if @streaming_service_account.cached_data["my_channel_id"].blank?
      @streaming_service_account.cached_data["my_channel_id"] = client.my_channel_id
      @streaming_service_account.save!
    end
    my_channel_id = decorated_streaming_service_account.my_channel_id
    live_stream = client.live_stream
    [my_channel_id, live_stream]
  end
end
