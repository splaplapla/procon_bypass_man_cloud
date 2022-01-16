module HasUniqueKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_unique_key
  end 

  private

  def generate_unique_key
    self.unique_key ||= SecureRandom.uuid
  end
end
