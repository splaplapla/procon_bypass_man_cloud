class Admin::AvailablePbmJobsController < Admin::Base
  def index
    @device = Device.find(params[:device_id])
  end
end
