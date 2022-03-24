class RemoteMacro < ApplicationRecord
  belongs_to :remote_macro_group

  acts_as_taggable_on :trigger_words
end
