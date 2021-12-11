class Admin::PbmJobs::ChangePbmVersionController < Admin::PbmJobsBase
  def create
    device = find_device
    pbm_job = Admin::PbmJob::CreateChangePbmVersionService.new(device: device).execute(next_version: params[:pbm_version])
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)
    redirect_to admin_device_path(device), notice: "アクションを実行リクエストを作成しました"
  rescue Admin::PbmJob::CreateChangePbmVersionService::NeedPbmenvError
    redirect_to admin_device_path(device), notice: "deviceでpbmenvが無効で実行することができません"
  end
end
