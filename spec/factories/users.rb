FactoryBot.define do
  factory :user do
    email { "admin@example.com" }
    password { "secret" }
    password_confirmation { "secret" }

    trait :is_admin do
      admin { true }
    end
  end
end
