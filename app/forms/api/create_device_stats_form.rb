class Api::CreateDeviceStatsForm
  include ActiveModel::Model

  validates :status, :pbm_session_id, presence: true
  validate :validate_status, if: ->{ status.present? }

  attr_accessor :status, :pbm_session_id

  def initialize(attrs)
    super(attrs)
  end

  private

  def validate_status
    unless DeviceStatus.statuses.keys.include?(status)
      errors.add(:status, :invalid)
    end
  end
end
