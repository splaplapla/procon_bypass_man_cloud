class Api::EventsController < Api::Base
  def create
    form = Api::CreateEventForm.new(event_params)
    form.validate!

    Event.create!(body: form.body,
                  event_type: form.event_type,
                  session_id: form.session_id,
                  hostname: form.hostname)
    render json: {}, status: :ok
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def event_params
    params.permit(:event_type, :hostname, :session_id, body: {})
  end
end
