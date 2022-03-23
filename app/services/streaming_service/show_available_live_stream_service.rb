class StreamingService::ShowAvailableLiveStreamService
  def initialize(streaming_service_account)
    @streaming_service_account = StreamingService::YoutubeLiveDecorator.new(streaming_service_account)
  end

  def execute
    client = StreamingService::YoutubeLiveClient.new(@streaming_service_account)
    if @streaming_service_account.my_channel_id.blank?
      @streaming_service_account.my_channel_id = client.my_channel_id
      @streaming_service_account.save!
    end

    my_channel_id = @streaming_service_account.my_channel_id
    live_stream = client.available_live_stream
    [my_channel_id, live_stream]
  end
end
