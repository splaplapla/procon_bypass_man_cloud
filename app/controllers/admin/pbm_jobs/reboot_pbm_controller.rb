class Admin::PbmJobs::RebootPbmController < Admin::PbmJobs
  def create
    @device = Device.find(params[:device_id])

    builder = PbmJobFactory.new(device_id: @device.id)
    builder.action = :reboot_pbm
    pbm_job = builder.build
    pbm_job.save!

    redirect_to admin_device_path(@device), notice: "アクションを実行リクエストを作成しました"
  end
end
