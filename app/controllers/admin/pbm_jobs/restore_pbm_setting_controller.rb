class Admin::PbmJobs::RestorePbmSettingController < Admin::PbmJobsBase
  def create
    device = find_device
    form = Admin::PbmJob::CreateRestorePbmSettingForm.new(user_id: current_user.id, saved_buttons_setting_id: params[:saved_buttons_setting_id])
    form.validate!
    pbm_job = Admin::PbmJob::CreateRestorePbmSettingJobService.new(device: device, saved_buttons_setting: form.saved_buttons_setting).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)
    redirect_to admin_device_path(device), notice: "アクションを実行リクエストを作成しました"
  rescue ActiveModel::ValidationError => e
    redirect_to admin_device_path(device), notice: "入力のバリデーションエラーになりました"
  end
end
