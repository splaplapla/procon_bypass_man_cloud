FactoryBot.define do
  factory :splatoon2_sketch do
    user
    name { "foo" }
    encoded_image { "" }
    binary_threshold { 0 }
    crop_data { {} }

    trait :has_image do
      encoded_image do
        Lib::Image2Base64.new(
          File.open(File.join(Rails.root, "spec", "files", "dummy.gif")),
          content_type: "image/gif"
        ).execute
      end
    end
  end
end
