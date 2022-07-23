class Device < ApplicationRecord
  include HasUniqueKey

  belongs_to :current_device_status, class_name: DeviceStatus.name, required: false
  belongs_to :user, required: false # あとでtrueにする

  has_many :pbm_sessions, dependent: :destroy
  has_many :events, through: :pbm_sessions
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :pbm_jobs, dependent: :destroy
  has_many :device_statuses, dependent: :destroy
  has_many :pbm_remote_macro_jobs, dependent: :destroy

  has_one :demo_device, dependent: :destroy

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
    if offline?
      return 'offline'
    end

    if current_device_status.nil?
      return 'offline'
    end

    if current_device_status.recent?
      current_device_status.status
    else
       'offline'
    end
  end

  # @return [String]
  def name_or_hostname
    name.presence || hostname
  end

  # @return [Boolean]
  def offline?
    current_device_status.nil?
  end

  # @return [void]
  def offline!
    update!(current_device_status_id: nil)
  end

  def has_available_new_pbm_version?
    return false unless pbm_version
    not ProconBypassManVersion.latest(name: pbm_version)[:is_latest]
  end
end
