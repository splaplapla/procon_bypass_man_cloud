class Device < ApplicationRecord
  belongs_to :current_device_status, class_name: DeviceStatus.name, required: false

  has_many :pbm_sessions, dependent: :destroy
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :pbm_jobs, dependent: :destroy
  has_many :device_statuses, dependent: :destroy
end
