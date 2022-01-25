class User < ApplicationRecord
  authenticates_with_sorcery!

  MAX_SAVED_BUTTONS_SETTINGS_COUNT = 10

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :saved_buttons_settings, length: { maximum: MAX_SAVED_BUTTONS_SETTINGS_COUNT }

  validates :email, uniqueness: true

  has_many :devices
  has_many :events, through: :devices
  has_many :saved_buttons_settings

  # @return [String]
  def profile_image_url
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end

  # @return [Boolean]
  def can_create_saved_buttons_settings?
    MAX_SAVED_BUTTONS_SETTINGS_COUNT > saved_buttons_settings.count
  end
end
