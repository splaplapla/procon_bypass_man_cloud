class Api::CreateEventForm
  include ActiveModel::Model

  validates :body, :event_type, :hostname, :session_id, :device_id, presence: true

  attr_accessor :body, :event_type, :hostname, :session_id, :device_id

  def initialize(attrs)
    super(attrs)
  end
end
