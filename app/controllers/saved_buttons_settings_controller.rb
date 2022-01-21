class SavedButtonsSettingsController < ApplicationController
  def index
    @saved_buttons_settings = current_user.saved_buttons_settings
  end

  def create
    form = SavedButtonsSettingForm.new(params.permit(:event_id, :name, :memo))
    event = current_user.events.find_by(id: form.event_id, event_type: [:reload_config, :load_config])
    if event.nil?
      return redirect_to "/saved_buttons_settings", alert: "設定ファイルを作成できませんでした"
    end

    setting = current_user.saved_buttons_settings.build(content: event.body, name: form.name, memo: form.memo)
    if setting.save
      redirect_to "/saved_buttons_settings", notice: "設定ファイルを作成できました"
    else
      redirect_to "/saved_buttons_settings", alert: "設定ファイルを作成できませんでした"
    end
  end

  def destroy
    saved_buttons_setting = current_user.saved_buttons_settings.find(params[:id])
    saved_buttons_setting.destroy
    redirect_to "/saved_buttons_settings", notice: '削除しました'
  end
end
