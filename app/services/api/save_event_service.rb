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
        pbm_session.events.create!(
          body: body,
          event_type: event_type,
        )

        enable_pbmenv = body["root_path"].start_with?("/usr/share/pbm/") && (body["use_pbmenv"] == "true")
        device.update_columns(pbm_version: body["pbm_version"], enable_pbmenv: enable_pbmenv)
      when "reload_config", "load_config"
        pbm_session.events.create!(
          body: body,
          event_type: event_type,
        )
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
