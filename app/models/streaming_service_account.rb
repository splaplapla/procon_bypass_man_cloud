class StreamingServiceAccount < ApplicationRecord
  belongs_to :streaming_service

  serialize :cached_data, JSON

  before_create do
    self.cached_data = {}
  end

  def expired_access_token?
    expires_at < Time.zone.now
  end
end
