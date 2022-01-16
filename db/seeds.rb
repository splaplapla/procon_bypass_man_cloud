# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


pbm_setting_content = <<~EOH
  fast_return = ProconBypassMan::Plugin::Splatoon2::Macro::FastReturn
  guruguru = ProconBypassMan::Plugin::Splatoon2::Mode::Guruguru

  install_macro_plugin fast_return
  install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey
  install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey
  install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey
  install_mode_plugin guruguru

  prefix_keys_for_changing_layer [:zr, :zl, :l]
  set_neutral_position 2100, 2000

  layer :up, mode: :manual do
    # flip :zr, if_pressed: :zr, force_neutral: :zl
    flip :zr, if_pressed: :zr, force_neutral: :zl
    flip :zl, if_pressed: [:y, :b, :zl]
    flip :a, if_pressed: [:a]
    flip :down, if_pressed: :down
    # disable [:up]
    macro fast_return.name, if_pressed: [:y, :b, :down]
    macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey, if_pressed: [:y, :b, :up]
    macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey, if_pressed: [:y, :b, :right]
    macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]
    remap :l, to: :zr
    left_analog_stick_cap cap: 1100, if_pressed: [:zl, :a], force_neutral: :a
  end
  layer :right, mode: guruguru.name
  layer :left do
  # flip :zr, if_pressed: :zr, force_neutral: :zl
    remap :l, to: :zr
  end
  layer :down do
    # flip :zl
    # flip :zr, if_pressed: :zr, force_neutral: :zl, flip_interval: "1F"
    remap :l, to: :zr
  end
EOH

device = Device.find_or_create_by!(uuid: "a", hostname: "hoge", user_id: nil)
device = Device.find_or_create_by!(uuid: "d1") do |d|
  d.hostname = "hoge"
  d.user_id = nil
end
device.saved_buttons_settings.create!(content: { "setting" => pbm_setting_content, "version" => 1.0, name: "title1" })
device.saved_buttons_settings.create!(content: { "setting" => pbm_setting_content, "version" => 3.0, name: "title2" })

user = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "hogehoge"
  user. password_confirmation = "hogehoge"
  user.admin = true
end
user.devices << device

pbm_session = device.pbm_sessions.create!(uuid: SecureRandom.uuid, hostname: "foo")
pbm_session.events.create!(event_type: :reload_config, body: pbm_setting_content)
pbm_session.events.create!(event_type: :load_config, body: pbm_setting_content)
