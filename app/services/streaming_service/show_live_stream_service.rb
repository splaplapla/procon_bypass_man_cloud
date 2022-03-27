class StreamingService::ShowLiveStreamService
  class AvailableVideoNotError < StandardError; end

  def initialize(streaming_service_account, video_id: )
    @streaming_service_account = StreamingService::YoutubeLiveDecorator.new(streaming_service_account)
    @video_id = video_id
  end

  # TODO 引数の数が変わったら再取得したい. 実装が変わったときに起きる
  # @raise [AvailableVideoNotError]
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

    if @streaming_service_account.video.id == @video_id
      ensure_can_execute!
    else
      begin
        @streaming_service_account.set_video(video_id: @video_id, values: client.active_streaming_video.to_h.values)
      rescue StreamingService::YoutubeLiveClient::NotLiveStreamError
        @streaming_service_account.set_video(video_id: @video_id, values: [@video_id])
        @streaming_service_account.video_is_not_live
        @streaming_service_account.save!
        raise(AvailableVideoNotError, "ライブ配信ではない")
      end
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
    raise AvailableVideoNotError, "動画が存在しませんでした"
  rescue StreamingService::YoutubeLiveClient::NotOwnerVideoError
    raise # TODO
  end

  private

  def ensure_can_execute!
    raise(AvailableVideoNotError, "ライブ配信ではない") if @streaming_service_account.video_is_live?
  end
end
