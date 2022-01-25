class SavedButtonsSettingsController < ApplicationController
  def index
    @saved_buttons_settings = current_user.saved_buttons_settings
  end

  # 別controller配下のview(modal)から送られる
  def create
    form = SavedButtonsSettingForm.new(params.permit(:event_id, :name, :memo))
    event = current_user.events.find_by(id: form.event_id, event_type: [:reload_config, :load_config])
    if event.nil?
      return redirect_to "/saved_buttons_settings", alert: "設定ファイルを作成できませんでした"
    end

    current_user.saved_buttons_settings.build(content: event.body, name: form.name, memo: form.memo)
    if current_user.save
      redirect_to "/saved_buttons_settings", notice: "設定ファイルを作成できました"
    else
      redirect_to "/saved_buttons_settings", alert: "設定ファイルを作成できませんでした"
    end
  end

  def update
    setting = current_user.saved_buttons_settings.find(params[:id])
    if setting.update(params.require(:saved_buttons_setting).permit(:name, :memo))
      redirect_to "/saved_buttons_settings", notice: "設定ファイルを更新できました"
    else
      redirect_to "/saved_buttons_settings", alert: "設定ファイルを更新できませんでした"
    end
  end

  def update_content
    saved_buttons_setting = current_user.saved_buttons_settings.find(params[:id])
    saved_buttons_setting.content['setting'] = params.require(:setting_of_content)
    if saved_buttons_setting.save
      redirect_to "/saved_buttons_settings", notice: "設定ファイルの内容を更新できました"
    else
      redirect_to "/saved_buttons_settings", alert: "設定ファイルの内容を更新できませんでした"
    end
  end

  def destroy
    saved_buttons_setting = current_user.saved_buttons_settings.find(params[:id])
    saved_buttons_setting.destroy
    redirect_to "/saved_buttons_settings", notice: '削除しました'
  end
end
