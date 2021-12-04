class Admin::PbmJobs::ChangePbmVersionController < Admin::PbmJobs
  def create
    device = Device.find(params[:device_id])
    Admin::ChangeVersionRequestService.new(device: device).execute(next_version: params[:pbm_version])
    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  rescue Admin::ChangeVersionRequestService::NeedPbmenvError
    redirect_to admin_device_path(@device), notice: "deviceでpbmenvが無効で実行することができません"
  end
end
