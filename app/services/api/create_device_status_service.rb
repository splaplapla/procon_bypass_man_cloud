class Api::CreateDeviceStatusService
  attr_accessor :device, :pbm_session_id

  def initialize(device: , pbm_session_id: )
    self.device = device
    self.pbm_session_id = pbm_session_id
  end

  def execute(status: )
    raise "unknown status" unless DeviceStatus.statuses.keys.include?(status)

    pbm_session = nil
    begin
      ApplicationRecord.transaction(requires_new: true) do
        pbm_session = PbmSession.find_or_create_by!(uuid: pbm_session_id) do |s|
          s.device = device
          s.hostname = "unknown"
        end
      end
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error e
      retry
    end

    ApplicationRecord.transaction do
      latest_device_status = device.device_statuses.last
      if latest_device_status.nil?
        device_status = device.device_statuses.create!(status: status, pbm_session: pbm_session)
        device.update!(current_device_status: device_status, last_access_at: Time.now)
      else
        if latest_device_status.status == status && latest_device_status.pbm_session_id == pbm_session.id
          latest_device_status.touch
          device.update_columns(last_access_at: Time.now)
        else
          device_status = device.device_statuses.create!(status: status, pbm_session: pbm_session)
          device.update!(current_device_status: device_status, last_access_at: Time.now)
        end

        # offlineになったらnilになる. その後デバイスからrunningが送られてきたらステータスを更新したい
        if device.current_device_status_id.nil?
          device.update!(current_device_status: device.device_statuses.last)
        end
      end
    end
  end
end
