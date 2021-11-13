class Event < ApplicationRecord
  serialize :body, JSON
end
