class Admin::SavedButtonsSettingsController < Admin::Base
  def index
    @settings = Device.find(params[:device_id]).saved_buttons_settings
  end

  def show
  end

  def create
    event = Event.where(event_type: [:load_config, :reload_config]).find(params[:event_id])
    event.pbm_session.device.saved_buttons_settings.create!(content: event.body)
    redirect_to admin_device_url(event.pbm_session.device), notice: "設定を保存しました"
  end
end
