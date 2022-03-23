class StreamingService::FetchChatMessagesService
  def initialize(streaming_service_account, video_id: )
    @streaming_service_account = StreamingService::YoutubeLiveDecorator.new(streaming_service_account)
    @video_id = video_id
  end

  # TODO videoキーとchat_idがなかったときに例外を投げる
  def execute
    video = @streaming_service_account.video
    client = StreamingService::YoutubeLiveClient.new(@streaming_service_account)
    client.video_id = @video_id
    client.chat_id = video.chat_id

    next_page_token, messages = client.chat_messages(
      page_token: @streaming_service_account.video_next_page_token
    )
    @streaming_service_account.video_next_page_token = next_page_token
    @streaming_service_account.save!

    messages
  end
end
