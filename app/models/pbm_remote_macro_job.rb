class PbmRemoteMacroJob < ApplicationRecord
  belongs_to :device

  serialize :steps, coder: JSON

  enum status: { queued: 0, in_progress: 5, processed: 10, failed: 15, canceled: 20 }

  def self.generate_uuid
    "prmpj_#{SecureRandom.uuid}"
  end
end
