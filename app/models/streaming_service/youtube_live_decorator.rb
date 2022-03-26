class StreamingService::YoutubeLiveDecorator
  def initialize(streaming_service_account)
    @streaming_service_account = streaming_service_account
  end

  # @return [StreamingService::YoutubeLive::Video]
  def video
    StreamingService::YoutubeLive::Video.new(
      *@streaming_service_account.cached_data.dig("video", "value")
    )
  end

  # @return [void]
  def set_video(video_id: , values: )
    @streaming_service_account.cached_data["video"] = { 'id' => video_id, 'value' => values }
  end

  # @return [Boolean]
  def video_is_nil?
    @streaming_service_account.cached_data["video"].nil?
  end

  # @return [void]
  def reset_video
    @streaming_service_account.cached_data["video"] = {}
  end

  # @return [Boolean]
  def video_is_live?
    !!@streaming_service_account.cached_data["video"]["not_live"]
  end

  # @return [void]
  def video_is_not_live
    @streaming_service_account.cached_data["video"]["not_live"] = true
  end

  # @return [String, NilClass]
  def my_channel_id
    @streaming_service_account.cached_data["my_channel_id"]
  end

  # @return [void]
  def my_channel_id=(value)
    @streaming_service_account.cached_data["my_channel_id"] = value
  end

  # @return [String]
  def video_next_page_token
    @streaming_service_account.cached_data["video"]["next_page_token"]
  end

  # @return [void]
  def video_next_page_token=(value)
    if @streaming_service_account.cached_data["video"]["next_page_token"] != value
      @streaming_service_account.cached_data["video"]["next_page_token"] = value
    end
  end

  private

  def method_missing(name, *args)
    @streaming_service_account.send(name, *args)
  end
end
