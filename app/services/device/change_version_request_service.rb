class Device::ChangeVersionRequestService
  # @param [Device] device
  def self.execute(device: , next_version: )
    raise "need next_version" if next_version.nil?

    builder = PbmJobFactory.new(device_id: device.id)
    # TODO これを消す
    builder.action = :change_pbm_version
    builder.args = { next_version: next_version }
    pbm_job = builder.build
    pbm_job.save!
    pbm_job
  end
end
