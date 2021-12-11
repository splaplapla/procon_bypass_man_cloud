# 使っていない
class Admin::PbmJobs::ReloadPbmSettingController < Admin::PbmJobsBase
  def create
    device = find_device
    pbm_job = Admin::PbmJob::CreateReloadPbmSettingService.new(device: device).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)
    redirect_to admin_device_path(device), notice: "アクションを実行リクエストを作成しました"
  end
end
