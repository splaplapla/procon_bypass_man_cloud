class Admin::PbmJobsBase < Admin::Base
  before_action :require_empty_pending_job

  private

  def require_empty_pending_job
    @device = Device.find(params[:device_id])
    if @device.pbm_jobs.wip.recent.present?
      redirect_to admin_device_path(@device), notice: "既に実行待ちのジョブがあるのでリクエストの作成は中止しました。"
    end
  end

  def find_device
    @device ||= Device.find(params[:device_id])
  end
end
