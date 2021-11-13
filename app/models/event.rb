class Event < ApplicationRecord
  serialize :body, JSON

  belongs_to :pbm_session
end
