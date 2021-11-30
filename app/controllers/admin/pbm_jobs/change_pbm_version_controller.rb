class Admin::PbmJobs::ChangePbmVersionController < Admin::PbmJobs
  def create
    device = Device.find(params[:device_id])
    Device::ChangeVersionRequestService.new(device: device).execute(next_version: params[:next_version])

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  rescue Device::ChangeVersionRequestService::NeedPbmenvError
    redirect_to admin_device_path(@device), notice: "deviceでpbmenvが無効で実行することができません"
  end
end
