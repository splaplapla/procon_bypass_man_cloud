FactoryBot.define do
  factory :device do
    hostname { "hai" }
    uuid { "m_#{SecureRandom.uuid}" }
  end
end
