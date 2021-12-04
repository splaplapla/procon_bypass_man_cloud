class Admin::PbmJobs::RestorePbmSettingController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])

    saved_buttons_setting = @device.saved_buttons_settings.find(params[:saved_buttons_setting_id])
    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :restore_pbm_setting,
      job_args: { setting: saved_buttons_setting.content, setting_name: saved_buttons_setting.name },
    ).build
    pbm_job.save!

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
