class Api::EventsController < Api::Base
  def create
    form = Api::CreateEventForm.new(event_params)
    form.validate!

    ApplicationRecord.transaction do
      pbm_session = PbmSession.find_or_create_by!(ulid: form.session_id) do |pbm_session|
        pbm_session.update!(hostname: form.hostname, ip_address: nil, user_id: nil)
      end

      case form.event_type
      when "boot"
        pbm_session.events.create!(
          body: form.body,
          event_type: form.event_type,
        )
      when "heartbeat"
        if(heartbeat_event = pbm_session.events.find_by(event_type: form.event_type))
          heartbeat_event.update!(body: form.body)
        else
          pbm_session.events.create!(event_type: :heartbeat, body: form.body)
        end
      when "error"
        pbm_session.events.create!(event_type: :error, body: form.body)
      end
    end

    render json: {}, status: :ok
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def event_params
    params.permit(:event_type, :hostname, :session_id, body: {})
  end
end
