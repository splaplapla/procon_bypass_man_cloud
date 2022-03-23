class StreamingService::YoutubeLive::ChatMessage < Struct.new(:body, :author_channel_id, :author_name, :owner, :moderator, :published_at)
end
