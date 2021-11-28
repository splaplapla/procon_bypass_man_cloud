class Api::CreateDeviceStatsForm
  include ActiveModel::Model

  validates :stats, presence: true
  validate :validate_stats, if: ->{ stats.present? }

  attr_accessor :stats

  def initialize(attrs)
    super(attrs)
  end

  private

  def validate_stats
    unless DeviceStatus.stats.keys.include?(stats)
      errors.add(:stats, :invalid)
    end
  end
end
