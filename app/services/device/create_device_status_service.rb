class Device::CreateDeviceStatusService
  attr_accessor :device

  def initialize(device: )
    self.device = device
  end

  def execute(status: )
    ApplicationRecord.transaction do
      device_status = device.device_statuses.create!(status: status)
      device.update!(current_device_status: device_status)
    end
  end
end
