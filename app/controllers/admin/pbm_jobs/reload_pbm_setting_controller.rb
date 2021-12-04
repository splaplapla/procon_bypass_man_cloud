class Admin::PbmJobs::ReloadPbmSettingController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])

    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :reload_pbm_setting,
    ).build
    pbm_job.save!

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
