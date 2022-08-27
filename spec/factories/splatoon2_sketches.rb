FactoryBot.define do
  factory :splatoon2_sketch do
    user
    name { "foo" }
    encoded_image { "" }
    binary_threshold { 0 }
    crop_data { {} }
  end
end
