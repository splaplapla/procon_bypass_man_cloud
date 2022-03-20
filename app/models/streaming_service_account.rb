class StreamingServiceAccount < ApplicationRecord
  belongs_to :streaming_service

  def expired_access_token?
    expires_at < Time.zone.now
  end
end