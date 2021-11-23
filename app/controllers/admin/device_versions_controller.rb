class Admin::DeviceVersionsController < Admin::Base
  def show
  end

  def current
    @device = Device.find(params[:device_id])
  end

  def change_request
    @device = Device.find(params[:device_id])
    Device::ChangeRequestVersionService.execute(device: @device)
    head :ok
  end
end
