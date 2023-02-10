class Devices::LogsController < ApplicationController
  def show
    @device = current_user.devices.find_by!(unique_key: params[:device_id])
    @latest_pbm_session = @device.pbm_sessions.last
    if @latest_pbm_session
      @pbm_session_events = @latest_pbm_session.events.order(id: :desc).limit(20)
    end
  end
end
