class Admin::PbmJobs::RestorePbmSettingController < Admin::PbmJobsBase
  def create
    device = Device.find(params[:device_id])
    form = Admin::PbmJob::CreateRestorePbmSettingForm.new(device_id: device.id, saved_buttons_setting_id: params[:saved_buttons_setting_id])
    form.validate!
    pbm_job = Admin::PbmJob::CreateRestorePbmSettingJobService.new(device: form.device, saved_buttons_setting: form.saved_buttons_setting).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)
    redirect_to admin_device_path(device), notice: "アクションを実行リクエストを作成しました"
  rescue ActiveModel::ValidationError => e
    redirect_to admin_device_path(device), notice: "入力のバリデーションエラーになりました"
  end
end
