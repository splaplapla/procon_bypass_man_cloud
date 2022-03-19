class StreamingService < ApplicationRecord
  belongs_to :user
  belongs_to :device, optional: true
  belongs_to :remote_macro_group, optional: true

  enum service_type: {
    youtube_live: 10,
    discord: 20,
  }
end
