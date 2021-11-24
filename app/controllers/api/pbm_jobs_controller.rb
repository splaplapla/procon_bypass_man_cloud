class Api::PbmJobsController < Api::Base
  def index
    device = Device.find(params[:device_id])
    render json: device.pbm_jobs.queued.map { |x| PbmJobSerializer.new(x) }
  end

  def update
    device = Device.find(params[:device_id])
    pbm_job = device.pbm_jobs.find(params[:id])

    # TODO forom object
    pbm_job.update!(status: params[:status])

    render json: PbmJobSerializer.new(pbm_job)
  end
end
