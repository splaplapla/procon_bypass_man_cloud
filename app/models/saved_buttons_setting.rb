class SavedButtonsSetting < ApplicationRecord
  has_one :public_saved_buttons_setting, dependent: :destroy

  belongs_to :user

  serialize :content, coder: JSON

  before_save :update_content_hash

  def setting_of_content
    content.dig("setting")
  end

  def explained_lines
    @explained_lines ||= SettingExplainService.new(text: content["setting"]).execute
  end

  def normalized_content
    cloned_content = content.clone
    cloned_content.transform_values do |value|
      if value.is_a?(String)
        value.gsub!("\r\n", "\n")
      end
    end

    cloned_content
  end

  private

  def update_content_hash
    setting = content["setting"]
    self.content_hash = Digest::SHA1.hexdigest(setting || '');
  end
end
