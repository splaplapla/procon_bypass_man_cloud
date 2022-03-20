class StreamingService::ShowVideoService
  def initialize(streaming_service_account, video_id: )
    @streaming_service_account = streaming_service_account
    @video_id = video_id
  end

  def execute
    client = StreamingService::YoutubeLiveClient.new(@streaming_service_account)
    client.video_id = @video_id

    if @streaming_service_account.cached_data["my_channel_id"].blank?
      @streaming_service_account.cached_data["my_channel_id"] = client.my_channel_id
    end

    if @streaming_service_account.cached_data["video"].blank?
      @streaming_service_account.cached_data["video"] = {}
    end
    if @streaming_service_account.cached_data.fetch("video") && @streaming_service_account.cached_data.dig("video", "id") != @video_id
      @streaming_service_account.cached_data["video"] = { 'id' => @video_id, 'value' => client.video.to_h.values }
    end

    @streaming_service_account.save!

    unless(my_channel_id = @streaming_service_account.cached_data["my_channel_id"])
      my_channel_id = client.my_channel_id
    end
    video =
      if @streaming_service_account.cached_data.dig("video", "id")
        StreamingService::YoutubeLiveClient::Video.new(
          *@streaming_service_account.cached_data.dig("video", 'value')
        )
      else
        client.video
      end
    return video
  end
end
