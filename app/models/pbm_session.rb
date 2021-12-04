class PbmSession < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :device_statuses, dependent: :destroy

  belongs_to :device
end
