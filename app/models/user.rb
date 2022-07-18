class User < ApplicationRecord
  include PlanCap

  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validate :validate_saved_buttons_settings_max_length

  validates :email, uniqueness: true

  has_many :devices, dependent: :destroy
  has_many :events, through: :devices
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :remote_macro_groups, dependent: :destroy
  has_many :remote_macros, through: :remote_macro_groups

  has_many :streaming_services

  # @return [String]
  def profile_image_url
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end

  # @return [Boolean]
  def can_create_saved_buttons_settings?
    max_saved_settings_size >= saved_buttons_settings.size
  end

  private

  def validate_saved_buttons_settings_max_length
    return if can_create_saved_buttons_settings?

    errors.add(:saved_buttons_settings, '登録可能な個数を超えています')
  end
end
