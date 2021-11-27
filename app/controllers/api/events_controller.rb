class Api::EventsController < Api::Base
  def create
    form = Api::CreateEventForm.new(event_params)
    form.validate!

    SaveEventService.execute!(
      session_id: form.session_id,
      hostname: form.hostname,
      event_type: form.event_type,
      body: form.body,
      device_id: form.device_id,
    )

    render json: {}, status: :ok
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def event_params
    params.permit(:event_type, :hostname, :session_id, :device_id, body: {})
  end
end
