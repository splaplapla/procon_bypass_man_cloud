class Device::ChangeVersionRequestService
  class NeedPbmenvError < StandardError; end

  attr_accessor :device

  # @param [Device] device
  def initialize(device: )
    self.device = device
  end

  # @param [String] next_version
  def execute(next_version: )
    raise "need next_version" if next_version.nil?
    raise NeedPbmenvError, "pbmenvが必要です" unless device.enable_pbmenv

    builder = PbmJobFactory.new(device_id: device.id)
    # TODO これを消す
    builder.action = :change_pbm_version
    builder.args = { pbm_version: next_version }
    pbm_job = builder.build
    pbm_job.save!
    pbm_job
  end
end
