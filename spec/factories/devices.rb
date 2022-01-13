FactoryBot.define do
  factory :device do
    hostname { "hai" }
    uuid { SecureRandom.uuid }
  end
end
