FactoryBot.define do
  factory :user do
    email { "admin@example.com" }
    password { "secret" }
    password_confirmation { "secret" }

    trait :has_admin_permission do
      admin { true }
    end
  end
end
