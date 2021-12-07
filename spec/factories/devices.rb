FactoryBot.define do
  factory :device do
    hostname { "hai" }
    uuid { SecureRandom.uuid }

    trait :is_admin do
      admin { true }
    end
  end
end
