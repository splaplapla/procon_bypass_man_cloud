class Device < ApplicationRecord
  include HasUniqueKey

  belongs_to :current_device_status, class_name: DeviceStatus.name, required: false
  belongs_to :user, required: false # あとでtrueにする

  has_many :pbm_sessions, dependent: :destroy
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :pbm_jobs, dependent: :destroy
  has_many :device_statuses, dependent: :destroy

  # @return [String]
  def push_token
    "pbm_job_#{uuid}"
  end
end
