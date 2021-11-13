class Api::CreateEventForm
  include ActiveModel::Model

  validates :body, :event_type, :hostname, presence: true

  attr_accessor :body, :event_type, :hostname

  def initialize(attrs)
    super(attrs)
  end
end
