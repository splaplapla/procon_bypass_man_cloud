class Api::CreateEventForm
  include ActiveModel::Model

  validates :body, :event_type, :hostname, :session_id, :device_id, presence: true
  validate :validate_device_id_format, if: :device_id

  attr_accessor :body, :event_type, :hostname, :session_id, :device_id

  

  private

  def validate_device_id_format
    unless device_id =~ /\A\w_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
      self.errors.add(:device_id, :invalid)
    end
  end
end
