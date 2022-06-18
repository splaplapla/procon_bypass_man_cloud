class StreamingService < ApplicationRecord
  include HasUniqueKey

  belongs_to :user
  belongs_to :device, optional: true
  belongs_to :remote_macro_group, optional: true

  has_one :streaming_service_account, dependent: :destroy

  enum service_type: {
    youtube_live: 10,
    twitch: 20,
  }

  validates :service_type, presence: true
  validate :prevent_to_update_service_type, on: :update

  # @return [StreamingServiceAccount]
  def streaming_service_account_with_decoration
    case
    when self.youtube_live?
      StreamingService::YoutubeLiveDecorator.new(streaming_service_account)
    when self.twitch?
      streaming_service_account
    else
      raise 'unknown service'
    end
  end

  private

  def prevent_to_update_service_type
    if changes[:service_type].present?
      self.errors.add(:service_type, :invalid)
    end
  end
end
