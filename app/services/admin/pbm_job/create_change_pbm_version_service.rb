class Admin::PbmJob::CreateChangePbmVersionService
  class NeedPbmenvError < StandardError; end

  attr_accessor :device

  # @param [Device] device
  def initialize(device: )
    self.device = device
  end

  # @param [String] next_version
  # @return [PbmJob]
  def execute(next_version: )
    raise "need next_version" if next_version.nil?
    raise NeedPbmenvError, "pbmenvが必要です" unless device.enable_pbmenv

    pbm_job = PbmJobFactory.new(
      device_id: device.id,
      action: :change_pbm_version,
      job_args: { pbm_version: next_version },
    ).build
    pbm_job.save!
    pbm_job
  end
end
