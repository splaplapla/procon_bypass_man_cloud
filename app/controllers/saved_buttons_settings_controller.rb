class SavedButtonsSettingsController < ApplicationController
  def index
    @saved_buttons_settings = current_user.saved_buttons_settings
  end
end
