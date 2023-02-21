class PbmJob < ApplicationRecord
  belongs_to :device

  serialize :args, JSON

  enum action: {
    change_pbm_version: 0,
    reboot_os: 5,
    stop_pbm: 10,
    reload_pbm_setting: 15,
    restore_pbm_setting: 20,
    report_porcon_status: 25,
  }
  enum status: { queued: 0, in_progress: 5, processed: 10, failed: 15, canceled: 20 }

  scope :recent, ->{ where("created_at > ?", 3.minutes.ago) }
  scope :wip, ->{ where(status: [:queued, :in_progress]) }

  validates :args, presence: true, if: ->{ restore_pbm_setting? || change_pbm_version? }
  validates :action, :uuid, presence: true

  def self.generate_uuid
    "rpj_#{SecureRandom.uuid}"
  end

  def can_cancel?
    queued? || in_progress?
  end
end
