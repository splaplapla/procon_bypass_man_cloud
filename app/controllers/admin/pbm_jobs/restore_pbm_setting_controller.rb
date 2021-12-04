class Admin::PbmJobs::RestorePbmSettingController < Admin::PbmJobs
  def create
    form = Admin::CreateRestorePbmSettingJobForm.new(device_id: params[:device_id], saved_buttons_setting_id: params[:saved_buttons_setting_id])
    form.validate!
    Admin::CreateRestorePbmSettingJobService.new(device: form.device, saved_buttons_setting: form.saved_buttons_setting).execute!

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  rescue ActiveModel::ValidationError => e
    redirect_to admin_device_path(@device), notice: "入力のバリデーションエラーになりました"
  end
end
