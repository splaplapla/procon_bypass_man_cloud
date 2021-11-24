class Admin::PbmJobs::RebootPbmController < Admin::Base
  def create
    @device = Device.find(params[:device_id])

    builder = PbmJobFactory.new(device_id: @device.id)
    builder.action = :reboot_pbm
    pbm_job = builder.build
    pbm_job.save!

    head :ok
  end
end
