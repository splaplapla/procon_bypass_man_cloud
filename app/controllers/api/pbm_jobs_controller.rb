class Api::PbmJobsController < Api::Base
  def index
    device = get_device
    render json: device.pbm_jobs.queued.map { |x| PbmJobSerializer.new(x) }
  end

  def update
    device = get_device
    pbm_job = device.pbm_jobs.find_by!(uuid: params[:id])

    # TODO forom object
    pbm_job.update!(status: pbm_params[:status])

    render json: PbmJobSerializer.new(pbm_job)
  end

  private

  def pbm_params
    params.require(:body).permit(:status)
  end
end
