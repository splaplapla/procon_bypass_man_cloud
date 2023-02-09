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

    User.find_each.each do |user|
      user_unique_key = user.id
      user_hash = {
        user: user.dup.attributes,
        devices: [],
        splatoon2_sketches: [],
      }
      user.devices.each do |device|
        device_hash = device.dup.attributes
        user_hash[:devices] << device_hash
      end

      user.splatoon2_sketches.each do |splatoon2_sketch|
        splatoon2_sketch_hash = splatoon2_sketch.dup.attributes
        user_hash[:splatoon2_sketches] << splatoon2_sketch_hash
      end

      dump[:users][user_unique_key] = user_hash
    end

    dump
  end
end
