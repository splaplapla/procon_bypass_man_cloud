class Devices::ProconPerformanceMetricsController < ApplicationController
  include ProconPerformanceMetricVisualizable

  def show
    @device = current_user.devices.find_by!(unique_key: params[:device_id])
    metrics = ProconPerformanceMetric::ReadService.new.execute(device_uuid: @device.uuid)
    visualize(metrics: metrics)
  end
end
