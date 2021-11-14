class PbmSession < ApplicationRecord
  has_many :events, dependent: :destroy

  belongs_to :device
end
