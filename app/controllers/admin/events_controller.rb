class Admin::EventsController < Admin::Base
  def index
    @events = Event.all.page(params[:page])
  end
end
