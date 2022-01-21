class SavedButtonsSetting < ApplicationRecord
  belongs_to :user

  serialize :content, JSON

  before_create do
    setting = content["setting"]
    self.content_hash ||= Digest::SHA1.hexdigest(setting || '');
  end
end
