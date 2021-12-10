class Admin::PbmJob::CreateReloadPbmSettingService
  # @param [Device] device
  def initialize(device: )
    @device = device
  end

  def execute!
    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :reload_pbm_setting,
    ).build
    pbm_job.save!
    pbm_job
  end
end

