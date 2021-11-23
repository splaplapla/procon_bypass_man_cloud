class Device::ChangeRequestVersionService
  # @param [Device] device
  def self.execute(device: )
    pbm_job = PbmJobBuilder.build(device_id: device.id)
    pbm_job.save!
    pbm_job
  end
end
