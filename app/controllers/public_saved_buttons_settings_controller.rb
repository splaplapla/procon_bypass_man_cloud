class PublicSavedButtonsSettingsController < ApplicationController
  skip_before_action :require_login, only: :show

  def show
    @public_saved_buttons_setting =  PublicSavedButtonsSetting.find_by!(unique_key: params[:id])
    @saved_buttons_setting = @public_saved_buttons_setting.saved_buttons_setting
  end

  def create
    saved_buttons_setting = SavedButtonsSetting.find(params[:saved_buttons_setting_id])
    public_saved_buttons_setting = saved_buttons_setting.create_public_saved_buttons_setting!
    redirect_to public_saved_buttons_setting_path(public_saved_buttons_setting.unique_key)
  end

  def destroy
    public_saved_buttons_setting = PublicSavedButtonsSetting.find(params[:id])
    public_saved_buttons_setting.destroy
    redirect_to saved_buttons_settings_path
  end
end
