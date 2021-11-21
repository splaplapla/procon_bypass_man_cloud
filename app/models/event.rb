class Event < ApplicationRecord
  serialize :body, JSON

  enum event_type: { boot: 0, reload_config: 10, load_config: 20, heartbeat: 30, error: 40 }

  belongs_to :pbm_session

  def self.event_types
    [ OpenStruct.new(name: :error),
      OpenStruct.new(name: :boot),
      OpenStruct.new(name: :load_config),
      OpenStruct.new(name: :reload_config),
    ]
  end

  def loading_config?
    reload_config? || load_config?
  end
end
