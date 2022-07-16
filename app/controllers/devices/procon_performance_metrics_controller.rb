class Devices::ProconPerformanceMetricsController < ApplicationController
  def show
    @device = current_user.devices.find_by!(unique_key: params[:device_id])
  end
end
