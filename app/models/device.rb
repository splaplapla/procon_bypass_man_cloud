class Device < ApplicationRecord
  has_many :pbm_sessions, dependent: :destroy
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :pbm_jobs, dependent: :destroy
  has_many :device_statuses, dependent: :destroy
end
