class RemoteMacroCommand < ApplicationRecord
  acts_as_taggable_on :trigger_words

  belongs_to :remote_macro
end
