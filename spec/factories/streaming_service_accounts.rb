FactoryBot.define do
  factory :streaming_service_account do
    name { "foo" }
    access_token { "foo" }
    refresh_token { "foo" }
    expires_at { Time.zone.now + 1.hours }
    uid { "foo" }
  end
end
