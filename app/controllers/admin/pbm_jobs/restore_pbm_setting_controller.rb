class Admin::PbmJobs::RestorePbmSettingController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])

    builder = PbmJobFactory.new(device_id: @device.id)
    builder.action = :restore_pbm_setting
    saved_buttons_setting = @device.saved_buttons_settings.find(params[:saved_buttons_setting_id])
    builder.args = { setting: saved_buttons_setting.content, setting_name: saved_buttons_setting.name }
    pbm_job = builder.build
    pbm_job.save!

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
