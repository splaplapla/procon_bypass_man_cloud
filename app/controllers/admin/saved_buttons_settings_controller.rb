class Admin::SavedButtonsSettingsController < Admin::Base
  def index
    @device = Device.find(params[:device_id])
    @settings = @device.saved_buttons_settings
  end

  # event由来で作成する
  def create
    event = Event.where(event_type: [:load_config, :reload_config]).find(params[:event_id])
    event.pbm_session.device.saved_buttons_settings.create!(content: event.body)
    redirect_to admin_device_url(event.pbm_session.device), notice: "設定を保存しました"
  end

  def update
    @setting = SavedButtonsSetting.find(params[:id])
    form = Admin::SavedButtonsSetting::UpdateForm.new(name: params[:name], memo: params[:memo], content: params[:content])
    if form.valid?
      @setting.update!(form.to_h)
      redirect_to admin_device_saved_buttons_settings_path, notice: "更新に成功しました"
    else
      redirect_to admin_device_saved_buttons_settings_path, notice: "更新に失敗しました"
    end
  end
end
