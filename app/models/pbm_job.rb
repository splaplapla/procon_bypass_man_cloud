class PbmJob < ApplicationRecord
  belongs_to :device
  serialize :args, JSON

  enum action: {
    change_pbm_version: 0,
    reboot_os: 5,
    stop_pbm: 10,
    reload_pbm_setting: 15,
    restore_pbm_setting: 20,
  }
  enum status: { queued: 0, in_progress: 5, processed: 10, failed: 15 }

  validates :args, presence: true, if: ->{ restore_pbm_setting? || change_pbm_version? }
  validates :action, :uuid, presence: true

  def self.generate_uuid
    "rpj_#{SecureRandom.uuid}"
  end
end
