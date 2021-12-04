# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

device = Device.find_or_create_by!(uuid: "a", hostname: "hoge", user_id: nil)
device.saved_buttons_settings.create!(content: { a: 1 }, name: "title1")
device.saved_buttons_settings.create!(content: { a: 1 }, name: "title2")

user = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "hogehoge"
  user. password_confirmation = "hogehoge"
  user.admin = true
end
user.devices << device
