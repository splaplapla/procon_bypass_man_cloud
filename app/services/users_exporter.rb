# postgresqlからmysqlに移行するために使う
#
# Usage:
#   File.write 'dump.json', UsersExporter.execute.to_json

class UsersExporter
  # @return [Hash]
  def self.execute
    dump = {
      global: nil,
      users: {},
    }

    [ GameSoft,
      RemoteMacroTemplate,
      ProconBypassManVersion,
    ].each do |model|
      dump[:global] ||= {}
      dump[:global][model.name] = model.all
    end

    # 移行対象外: remote_macros, remote_macro_groups
    User.find_each.each do |user|
      user_unique_key = user.id
      user_hash = { user: user.dup.attributes.with_indifferent_access }
      user_hash[:devices] = []
      user_hash[:splatoon2_sketches] = []
      user_hash[:saved_buttons_settings] = []

      user.devices.each do |device|
        device_hash = { device: device.dup.attributes.with_indifferent_access }
        device_hash[:events] = []
        device_hash[:pbm_sessions] = []

        device.events.each do |event|
          device_hash[:events] << event.dup.attributes.with_indifferent_access
        end

        device.pbm_sessions.each do |pbm_session|
          device_hash[:pbm_sessions] << pbm_session.dup.attributes.with_indifferent_access
        end

        user_hash[:devices] << device_hash
      end

      user.saved_buttons_settings.each do |saved_buttons_setting|
        dumped_saved_buttons_setting = saved_buttons_setting.dup.attributes.with_indifferent_access
        dumped_saved_buttons_setting[:public_saved_buttons_setting] = !!saved_buttons_setting.public_saved_buttons_setting
        user_hash[:saved_buttons_settings] << dumped_saved_buttons_setting
      end

      user.splatoon2_sketches.each do |splatoon2_sketch|
        splatoon2_sketch_hash = splatoon2_sketch.dup.attributes.with_indifferent_access
        user_hash[:splatoon2_sketches] << splatoon2_sketch_hash
      end

      dump[:users][user_unique_key] = user_hash
    end

    dump
  end
end
