class Admin::DevicesController < Admin::Base
  def index
    @devices = Device.all.page(params[:page]).order(id: :desc)
  end

  def show
    @device = Device.find(params[:id])
  end
end
