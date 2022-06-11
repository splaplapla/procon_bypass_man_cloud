class StreamingService < ApplicationRecord
  include HasUniqueKey

  belongs_to :user
  belongs_to :device, optional: true
  belongs_to :remote_macro_group, optional: true

  has_one :streaming_service_account, dependent: :destroy

  enum service_type: {
    youtube_live: 10,
    twitch: 20,
  }

  validates :service_type, presence: true
end
