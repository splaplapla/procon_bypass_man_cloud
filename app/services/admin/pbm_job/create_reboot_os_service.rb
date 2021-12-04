class Admin::PbmJob::CreateRebootOsService
  # @param [Device] device
  def initialize(device: )
    @device = device
  end

  def execute!
    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :reboot_os,
    ).build
    pbm_job.save!
  end
end
