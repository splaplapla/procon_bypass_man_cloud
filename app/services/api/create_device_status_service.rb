class Api::CreateDeviceStatusService
  attr_accessor :device, :pbm_session_id

  def initialize(device: , pbm_session_id: )
    self.device = device
    self.pbm_session_id = pbm_session_id
  end

  def execute(status: )
    raise "unknown status" unless DeviceStatus.statuses.keys.include?(status)
    pbm_session = PbmSession.find_by!(uuid: pbm_session_id)

    ApplicationRecord.transaction do
      latest_device_status = device.device_statuses.last
      if latest_device_status.nil?
        device_status = device.device_statuses.create!(status: status, pbm_session: pbm_session)
        device.update!(current_device_status: device_status)
      else
        if latest_device_status.status == status && latest_device_status.pbm_session_id == pbm_session.id
          latest_device_status.touch
          device.update_columns(last_access_at: Time.now)
        else
          device_status = device.device_statuses.create!(status: status, pbm_session: pbm_session)
          device.update!(current_device_status: device_status)
        end
      end
    end
  end
end
