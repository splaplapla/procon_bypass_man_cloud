class Admin::PbmSessionsController < Admin::Base
  def index
    @device = Device.find(params[:device_id])
    @pbm_sessions = @device.pbm_sessions.page(params[:page]).order(id: :desc)
    @device_statuses = @device.device_statuses.order(id: :desc).limit(10)
  end

  def show
    @device = Device.find(params[:device_id])
    @pbm_session = @device.pbm_sessions.find(params[:id])
    @events = @pbm_session.events.limit(20).order(id: :desc)
    @device_statuses = @pbm_session.device_statuses.order(id: :desc).limit(10)
  end
end
