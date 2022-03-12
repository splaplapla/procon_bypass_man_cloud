class RemoteMacroGroup < ApplicationRecord
  belongs_to :user

  has_many :remote_macros, dependent: :destroy
end
