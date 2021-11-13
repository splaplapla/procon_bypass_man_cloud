class SaveEventService
  def self.execute!(session_id: , hostname: , event_type: , body: )
    ApplicationRecord.transaction do
      pbm_session = PbmSession.find_or_create_by!(ulid: session_id) do |pbm_session|
        pbm_session.update!(hostname: hostname, ip_address: nil, user_id: nil)
      end

      case event_type
      when "boot"
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
