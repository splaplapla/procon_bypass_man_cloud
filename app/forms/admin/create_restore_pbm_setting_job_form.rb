class Admin::CreateRestorePbmSettingJobForm
  include ActiveModel::Model

  validates :device_id, :saved_buttons_setting_id, presence: true

  attr_accessor :device_id, :saved_buttons_setting_id

  def initialize(attrs)
    super(attrs)
  end

  def device
    @device ||= Device.find(device_id)
  end

  def saved_buttons_setting
    @saved_buttons_setting ||= device.saved_buttons_settings.find(saved_buttons_setting_id)
  end
end
