class Api::PbmJobsController < Api::Base
  def index
    device = Device.find(params[:device_id])
    render json: device.pbm_jobs.queued.map { |x| PbmJobSerializer.new(x) }
  end
end
