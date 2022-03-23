class StreamingService::YoutubeLive::ChatMessage < Struct.new(:body, :author_channel_id, :author_name, :owner, :moderator, :published_at)
  def to_trigger_word
    body.remove(/^!/)
  end
end
