class DevicesController < ApplicationController
  def index
    @devices = current_user.devices
  end

  def show
    @device = current_user.devices.find_by!(uuid: params[:id])
  end
end
