class Api::SaveEventService
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
        pbm_session.events.create!(body: body, event_type: event_type)
        enable_pbmenv = body["root_path"].start_with?("/usr/share/pbm/") && body["use_pbmenv"]
        device.update_columns(pbm_version: body["pbm_version"], enable_pbmenv: enable_pbmenv)
      when "completed_upgrade_pbm"
        ActionCable.server.broadcast(device.web_push_token, { type: :completed_upgrade_pbm })
      when "start_reboot"
        pbm_session.events.create!(body: body, event_type: event_type)
        ActionCable.server.broadcast(device.web_push_token, { type: :start_reboot })
      when "load_config"
        pbm_session.events.create!(body: body, event_type: event_type)
      when "reload_config"
        pbm_session.events.create!(body: body, event_type: event_type)
        ActionCable.server.broadcast(device.web_push_token, { type: :reload_config })
      when "error_reload_config"
        pbm_session.events.create!(event_type: :error, body: body)
        ActionCable.server.broadcast(device.web_push_token, { type: :error_reload_config, reason: body["text"] || '不明' })
      when "heartbeat"
        if(heartbeat_event = pbm_session.events.find_by(event_type: event_type))
          heartbeat_event.update!(body: body)
        else
          pbm_session.events.create!(event_type: :heartbeat, body: body)
        end
      when "error"
        pbm_session.events.create!(event_type: :error, body: body)
      end
    end
  end
end
