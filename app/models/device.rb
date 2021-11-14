class Device < ApplicationRecord
  has_many :pbm_sessions, dependent: :destroy
end
