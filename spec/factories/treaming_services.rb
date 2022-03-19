FactoryBot.define do
  factory :streaming_service do
    name { "foo" }
    service_type { StreamingService.service_types[:youtube_live] }
  end
end
