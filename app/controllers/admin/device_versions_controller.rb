class Admin::DeviceVersionsController < Admin::Base
  def show
  end

  def current
    @device = Device.find(params[:device_id])
  end
end
