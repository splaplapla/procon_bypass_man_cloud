class PbmJob < ApplicationRecord
  belongs_to :device

  enum action: { change_pbm_version: 0, reboot_os: 5, reboot_pbm: 10 }
  enum status: { queued: 0, in_progress: 5, processed: 10, failed: 15 }
end
