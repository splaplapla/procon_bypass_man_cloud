class SavedButtonsSetting < ApplicationRecord
  serialize :content, JSON
end
