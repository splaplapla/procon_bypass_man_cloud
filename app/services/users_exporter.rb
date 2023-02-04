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
      user_hash = { user: user.dup.attributes, devices: [] }
      user.devices.each do |device|
        device_hash = device.dup.attributes
        user_hash[:devices] << device_hash
      end

      dump[:users][user_unique_key] = user_hash
    end

    dump
  end
end
