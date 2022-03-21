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
    client.my_channel_id = @streaming_service_account.cached_data["my_channel_id"]

    if @streaming_service_account.cached_data["video"].blank?
      @streaming_service_account.cached_data["video"] = {}
    end
    if @streaming_service_account.cached_data.fetch("video") && @streaming_service_account.cached_data.dig("video", "id") != @video_id
      @streaming_service_account.cached_data["video"] = { 'id' => @video_id, 'value' => client.video.to_h.values }
      # TODO 引数の数が変わったら再取得したい. 実装が変わったときに起きる
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
        client.active_streaming_video
      end
    return video
  end
end
