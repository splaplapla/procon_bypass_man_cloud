class Admin::DevicesController < Admin::Base
  def index
    @devices = Device.all.page(params[:page]).order(id: :desc)
  end

  def show
    @device = Device.find(params[:id])
    @pbm_sessions = @device.pbm_sessions.limit(50).order(id: :desc)
    @device_statuses = @device.device_statuses.order(id: :desc).limit(10)
  end
end
