class Admin::PbmJobs::RebootOsController < Admin::Base
  def create
    @device = Device.find(params[:device_id])

    # TODO serviceにする
    builder = PbmJobFactory.new(device_id: @device.id)
    builder.action = :reboot_os
    pbm_job = builder.build
    pbm_job.save!

    head :ok
  end
end
