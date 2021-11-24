class PbmJobBuilder
  def self.build(device_id: )
    device = Device.find_by(id: device_id)
    device.pbm_jobs.build(action: :change_pbm_version, status: :queued, uuid: SecureRandom.uuid, args: [])
  end
end
