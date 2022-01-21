class SavedButtonsSettingForm
  include ActiveModel::Model

  attr_accessor :event_id, :name, :memo

  validates :event_id, presence: true
end
