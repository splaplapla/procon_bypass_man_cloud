class Admin::PbmJob::CreateRestorePbmSettingForm
  include ActiveModel::Model

  validates :user_id, :saved_buttons_setting_id, presence: true

  attr_accessor :user_id, :saved_buttons_setting_id

  def initialize(attrs)
    super(attrs)
  end

  def user
    @user ||= User.find(user_id)
  end

  def saved_buttons_setting
    @saved_buttons_setting ||= user.saved_buttons_settings.find(saved_buttons_setting_id)
  end
end
