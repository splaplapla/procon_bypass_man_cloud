class RemoteMacroTemplate < ApplicationRecord
  belongs_to :game_soft, counter_cache: true
end
