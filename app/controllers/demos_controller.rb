class DemosController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def show
    logout

    @device = Device.joins(:demo_device).first
    if @device.nil?
      return redirect_to root_url, alert: "デモページを表示できませんでした"
    end

    @is_demo = true
    @saved_buttons_settings = []
    @latest_loading_config_event = @device.latest_loading_config_event
    if @latest_loading_config_event
      @saved_buttons_setting_form = SavedButtonsSettingForm.new(event_id: @latest_loading_config_event.id)
    end
    render "devices/show"
  end
end
