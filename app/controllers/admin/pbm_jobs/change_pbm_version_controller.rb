class Admin::PbmJobs::ChangePbmVersionController < Admin::Base
  def create
    @device = Device.find(params[:device_id])
    Device::ChangeVersionRequestService.execute(device: @device)
    head :ok
  end
end
