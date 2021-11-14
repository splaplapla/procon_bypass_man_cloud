class Admin::EventsController < Admin::Base
  def index
    @events = Event.all
    if params[:pbm_session_id]
      pbm_session = PbmSession.find(params[:pbm_session_id])
      @events = @events.where(pbm_session_id: pbm_session)
      @device = pbm_session.device
    end

    @events = @events.page(params[:page]).order(id: :desc)
  end
end
