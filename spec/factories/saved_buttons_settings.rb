FactoryBot.define do
  factory :saved_buttons_setting do
    content = <<~EOH
      prefix_keys_for_changing_layer [:zr, :r, :zl, :l]\n
      set_neutral_position 1000, 1000
    EOH

    content { { setting: content } }
    name { "title2" }
  end
end
