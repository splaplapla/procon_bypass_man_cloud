class Admin::PbmJobs::RebootOsController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])
    Admin::PbmJob::CreateRebootOsService.new(device: @device).execute!
    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
