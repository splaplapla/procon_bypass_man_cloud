class Admin::PbmJobs::RebootOsController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])

    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :reboot_os,
    ).build
    pbm_job.save!

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
