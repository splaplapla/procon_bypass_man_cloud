class Admin::SavedButtonsSettingsController < Admin::Base
  def create
    event = Event.where(event_type: :load_config, :reload_config).find(params[:event_id])
  end
end
