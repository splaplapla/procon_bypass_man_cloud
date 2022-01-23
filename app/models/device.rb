class Device < ApplicationRecord
  include HasUniqueKey

  belongs_to :current_device_status, class_name: DeviceStatus.name, required: false
  belongs_to :user, required: false # あとでtrueにする

  has_many :pbm_sessions, dependent: :destroy
  has_many :events, through: :pbm_sessions
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :pbm_jobs, dependent: :destroy
  has_many :device_statuses, dependent: :destroy

  # @return [String]
  def push_token
    "pbm_job_#{uuid}"
  end

  # @return [String]
  def web_push_token
    unique_key
  end

  # @return [Event, NilClass]
  def latest_loading_config_event
    sessions_has_config = pbm_sessions.
      joins(:events).
      where(events: { event_type: [:reload_config, :load_config]})
    Event.where(pbm_sessions: sessions_has_config).where(event_type: [:reload_config, :load_config]).order(created_at: :desc).limit(1).first
  end

  # @return [String]
  def current_device_status_name
    if current_device_status&.recent?
      current_device_status.status
    else
      "信号なし"
    end
  end
end
