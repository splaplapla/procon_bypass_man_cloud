class Admin::PbmJobs < Admin::Base
  before_action :require_empty_pending_job

  def has_no_pending_job
    @device = Device.find(params[:device_id])
    if @device.pbm_jobs.queued.present?
      redirect_to admin_device_path(@device), notice: "既に実行待ちのジョブがあるのでリクエストの作成は中止しました。"
    end
  end
end
