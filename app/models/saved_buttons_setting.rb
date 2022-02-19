class SavedButtonsSetting < ApplicationRecord
  belongs_to :user

  serialize :content, JSON

  before_save :update_content_hash

  def setting_of_content
    content.dig("setting")
  end

  private

  def update_content_hash
    setting = content["setting"]
    self.content_hash = Digest::SHA1.hexdigest(setting || '');
  end
end
