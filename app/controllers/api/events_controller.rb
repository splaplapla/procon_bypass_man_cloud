class Api::EventsController < Api::Base
  def create
    form = Api::CreateEventForm.new(event_params)
    form.validate!

    Event.create!(body: form.body,
                  event_type: form.event_type,
                  hostname: form.hostname)
    render plain: :a
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def event_params
    params.permit(:body, :event_type, :hostname)
  end
end
