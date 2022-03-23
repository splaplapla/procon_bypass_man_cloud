class StreamingService::YoutubeLiveDecorator
  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  def video
    StreamingService::YoutubeLiveClient::Video.new(
      *@streaming_service_account.cached_data["video"]["value"]
    )
  end

  def my_channel_id
    @streaming_service_account.cached_data["my_channel_id"]
  end

  def my_channel_id=(value)
    @streaming_service_account.cached_data["my_channel_id"] = value
  end

  def video_next_page_token
    @streaming_service_account.cached_data["video"]["next_page_token"]
  end

  def video_next_page_token=(value)
    @streaming_service_account.cached_data["video"]["next_page_token"] = value
  end

  private

  def method_missing(name, *args)
    @streaming_service_account.send(name, *args)
  end
end
