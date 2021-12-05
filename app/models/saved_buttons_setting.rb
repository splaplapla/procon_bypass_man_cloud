class SavedButtonsSetting < ApplicationRecord
  belongs_to :device

  serialize :content, JSON
end
