class Admin::PbmJobs::ChangePbmVersionController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])
    Device::ChangeVersionRequestService.execute(device: @device, next_version: params[:next_version])

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
