class StreamingService::YoutubeLiveDecorator
  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  def video
    StreamingService::YoutubeLive::Video.new(
      *@streaming_service_account.cached_data["video"]["value"]
    )
  end

  def set_video(video_id: , values: )
    @streaming_service_account.cached_data["video"] = { 'id' => video_id, 'value' => values }
  end

  def video_is_nil?
    @streaming_service_account.cached_data["video"].blank?
  end

  def reset_video
    @streaming_service_account.cached_data["video"] = {}
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
