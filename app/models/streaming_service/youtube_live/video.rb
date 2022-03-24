class StreamingService::YoutubeLive::Video < Struct.new(:id, :published_at, :title, :description, :thumbnails_high_url, :chat_id)
  def published_at
    super.to_time # cached_dataからdeserializeすると文字列になっているので
  end
end
