class StreamingService::ShowLiveStreamService
  def initialize(streaming_service_account, video_id: )
    @streaming_service_account = StreamingService::YoutubeLiveDecorator.new(streaming_service_account)
    @video_id = video_id
  end

  def execute
    client = StreamingService::YoutubeLiveClient.new(@streaming_service_account)
    client.video_id = @video_id

    if @streaming_service_account.my_channel_id.blank?
      @streaming_service_account.my_channel_id = client.my_channel_id
    end
    client.my_channel_id = @streaming_service_account.my_channel_id

    if @streaming_service_account.video_is_nil?
      @streaming_service_account.reset_video
    end

    # TODO 引数の数が変わったら再取得したい. 実装が変わったときに起きる
    if @streaming_service_account.video.id != @video_id
      @streaming_service_account.set_video(video_id: @video_id, values: client.active_streaming_video.to_h.values)
    end
    @streaming_service_account.save!

    video = if @streaming_service_account.video.id
              @streaming_service_account.video
            else
              client.active_streaming_video
            end
    return video
  rescue StreamingService::YoutubeLiveClient::UnexpectedError
    raise # TODO
  rescue StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError
    raise # TODO
  rescue StreamingService::YoutubeLiveClient::VideoNotFoundError
    raise # TODO
  rescue StreamingService::YoutubeLiveClient::NotOwnerVideoError
    raise # TODO
  rescue StreamingService::YoutubeLiveClient::NotLiveStreamError
    raise # TODO
  end
end
