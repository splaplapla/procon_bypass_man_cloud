class DeviceStatus < ApplicationRecord
  belongs_to :device

  enum status: {
    initialized: 0,
    running: 5,
    connected_but_sleeping: 10,
    device_error: 15,
    connected_but_error: 20,
    connected_but_setting_syntax_error: 25,
  }
end
