class PbmSession < ApplicationRecord
  has_many :events, dependent: :destroy
end
