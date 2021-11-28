class Device::CreateDeviceStatusService
  attr_accessor :device

  def initialize(device: )
    self.device = device
  end

  def execute(status: )
    raise "unknown status" unless DeviceStatus.statuses.keys.include?(status)

    ApplicationRecord.transaction do
      latest_device_status = device.device_statuses.last
      if latest_device_status.nil?
        device_status = device.device_statuses.create!(status: status)
        device.update!(current_device_status: device_status)
      else
        if latest_device_status.status == status
          latest_device_status.touch
        else
          device_status = device.device_statuses.create!(status: status)
          device.update!(current_device_status: device_status)
        end
      end
    end
  end
end
