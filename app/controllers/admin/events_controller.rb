class Admin::EventsController < Admin::Base
  def index
    @events = Event.all.includes(pbm_session: :device)
    if event_params[:event_type].present?
      @events = @events.where(event_type: event_params[:event_type])
    end
    @events = @events.page(params[:page]).order(id: :desc)
  end

  private

  def event_params
    params.fetch(:event, {}).permit(:event_type)
  end
end
