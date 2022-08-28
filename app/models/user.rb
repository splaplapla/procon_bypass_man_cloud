class User < ApplicationRecord
  include PlanCap

  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true

  has_many :devices, dependent: :destroy
  has_many :events, through: :devices
  has_many :saved_buttons_settings, dependent: :destroy
  has_many :remote_macro_groups, dependent: :destroy
  has_many :remote_macros, through: :remote_macro_groups
  has_many :splatoon2_sketches, dependent: :destroy

  has_many :streaming_services

  # @return [String]
  def profile_image_url
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}"
  end

  # @return [Boolean]
  def can_create_saved_buttons_settings?
    max_saved_settings_size > saved_buttons_settings.count
  end

  # @return [Boolean]
  def can_have_another_devices?
    max_devices_size > devices.count
  end

  # @return [Boolean]
  def can_have_another_splatoon2_sketches?
    max_devices_size > splatoon2_sketches.count
  end

  # @return [Boolean]
  # TODO サービスクラスにする
  def add_saved_buttons_setting(new_add_saved_buttons_setting)
    return false unless can_create_saved_buttons_settings?

    self.saved_buttons_settings << new_add_saved_buttons_setting
    return true
  end
end
