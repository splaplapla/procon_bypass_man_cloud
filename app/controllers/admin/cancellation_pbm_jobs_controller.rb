class Admin::CancellationPbmJobsController < Admin::Base
  def create
    pbm_job = PbmJob.find(params[:pbm_job_id])
    pbm_job.canceled!
    redirect_to admin_device_path(pbm_job.device), notice: "アクションをキャンセルしました"
  end
end
