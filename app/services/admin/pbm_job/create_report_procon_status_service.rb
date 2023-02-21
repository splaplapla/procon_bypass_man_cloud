class Admin::PbmJob::CreateReportProconStatusService
  # @param [Device] device
  def initialize(device: )
    @device = device
  end

  # @return [PbmJob]
  def execute!
    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :report_porcon_status,
    ).build
    pbm_job.save!
    pbm_job
  end
end
