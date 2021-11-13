class Admin::EventsController < Admin::Base
  def index
    @events = Event.all.page(params[:page]).order(id: :desc)
  end
end
