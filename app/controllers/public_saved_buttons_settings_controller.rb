class PublicSavedButtonsSettingsController < ApplicationController
  skip_before_action :require_login, only: :show

  def show
    @public_saved_buttons_setting =  PublicSavedButtonsSetting.find_by!(unique_key: params[:id])
    @saved_buttons_setting = @public_saved_buttons_setting.saved_buttons_setting
  end

  def create
  end
end
