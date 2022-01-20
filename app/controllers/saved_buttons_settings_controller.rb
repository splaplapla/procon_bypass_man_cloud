class SavedButtonsSettingsController < ApplicationController
  def index
    @saved_buttons_settings = current_user.saved_buttons_settings
  end

  def destroy
    saved_buttons_setting = current_user.saved_buttons_settings.find(params[:id])
    saved_buttons_setting.destroy
    redirect_to "/saved_buttons_settings", notice: '削除しました'
  end
end
