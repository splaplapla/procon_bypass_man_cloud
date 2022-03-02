class PublicSavedButtonsSetting < ApplicationRecord
  include HasUniqueKey

  belongs_to :saved_buttons_setting
end
