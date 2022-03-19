class StreamingService < ApplicationRecord
  belongs_to :user

  enum service_type: {
    youtube_live: 10,
    discord: 20,
  }
end
