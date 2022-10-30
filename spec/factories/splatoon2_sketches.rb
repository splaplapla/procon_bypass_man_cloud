FactoryBot.define do
  factory :splatoon2_sketch do
    user
    name { "foo" }
    encoded_image { "" }
    binary_threshold { 0 }
    crop_data { { a: 1 }.to_json }

    trait :has_image do
      encoded_image do
        Lib::Image2Base64.new(
          File.open(File.join(Rails.root, "spec", "files", "t.jpeg")),
          content_type: "image/jpeg"
        ).execute
      end
    end

    trait :has_png_image do
      encoded_image do
        Lib::Image2Base64.new(
          File.open(File.join(Rails.root, "spec", "files", "p.png")),
          content_type: "image/png"
        ).execute
      end
    end
  end
end
