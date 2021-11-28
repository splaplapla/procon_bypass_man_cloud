class Device::CreateDeviceStatusService
  attr_accessor :device

  def initialize(device: )
    self.device = device
  end

  def execute(status: )
    ApplicationRecord.transaction do
      device.device_statuses.create!(status: status)
      device.touch
    end
  end
end
