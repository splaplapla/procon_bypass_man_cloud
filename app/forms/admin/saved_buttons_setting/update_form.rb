class Admin::SavedButtonsSetting::UpdateForm
  include ActiveModel::Model

  attr_accessor :name, :memo, :content

  def initialize(attrs)
    super
  end

  def to_h
    { name: name, memo: memo, content: content }.compact
  end
end
