class Api::SaveEventService
  # @return [Event, nil]
  def self.execute!(session_id: , hostname: , event_type: , body: , device_id: )
    ApplicationRecord.transaction do
      device =
        if(device = Device.find_by(uuid: device_id))
          device.update!(hostname: hostname)
          device
        else
          Device.create!(uuid: device_id, hostname: hostname, user_id: nil)
        end
      device.update_columns(last_access_at: Time.zone.now)

      pbm_session = device.pbm_sessions.find_or_create_by!(uuid: session_id) do |pbm_session|
        pbm_session.assign_attributes(hostname: hostname, ip_address: nil)
      end

      case event_type
      when "boot"
        event = pbm_session.events.create!(body: body, event_type: event_type)
        enable_pbmenv = body["root_path"].start_with?("/usr/share/pbm/") && body["use_pbmenv"]
        device.update_columns(pbm_version: body["pbm_version"], enable_pbmenv: enable_pbmenv)
        ActionCable.server.broadcast(device.web_push_token, { type: :booted })
        next event
      when "completed_upgrade_pbm"
        ActionCable.server.broadcast(device.web_push_token, { type: :completed_upgrade_pbm })
        next nil
      when "start_reboot"
        event = pbm_session.events.create!(body: body, event_type: event_type)
        ActionCable.server.broadcast(device.web_push_token, { type: :start_reboot })
        next event
      when "load_config"
        event = pbm_session.events.create!(body: body, event_type: event_type)
        ActionCable.server.broadcast(device.web_push_token, { type: :loaded_config })
        next event
      when "reload_config"
        event = pbm_session.events.create!(body: body, event_type: event_type)
        ActionCable.server.broadcast(device.web_push_token, { type: :reload_config })
        next event
      when "error_reload_config"
        event = pbm_session.events.create!(event_type: :error, body: body)
        ActionCable.server.broadcast(device.web_push_token, { type: :error_reload_config, reason: body["text"] || '不明' })
        next event
      when "heartbeat"
        if(heartbeat_event = pbm_session.events.find_by(event_type: event_type))
          heartbeat_event.update!(body: body)
          next nil
        else
          next pbm_session.events.create!(event_type: :heartbeat, body: body)
        end
      when "error"
        next pbm_session.events.create!(event_type: :error, body: body)
      end
    end
  end
end
