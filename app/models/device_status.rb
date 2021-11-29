class DeviceStatus < ApplicationRecord
  belongs_to :device
  belongs_to :pbm_session

  enum status: {
    initialized: 0,
    running: 5,
    connected_but_sleeping: 10,
    device_error: 15,
    connected_but_error: 20,
    setting_syntax_error_and_shutdown: 30,
  }
end
