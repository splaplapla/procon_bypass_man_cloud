class Event < ApplicationRecord
  serialize :body, JSON

  belongs_to :pbm_session

  def self.event_types
    [ OpenStruct.new(name: :error),
      OpenStruct.new(name: :boot),
      OpenStruct.new(name: :load_config),
      OpenStruct.new(name: :reload_config),
    ]
  end
end
