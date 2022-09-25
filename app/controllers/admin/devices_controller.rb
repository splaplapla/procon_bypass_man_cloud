class Admin::DevicesController < Admin::Base
  include ProconPerformanceMetricVisualizable

  def index
    @devices = Device.all.page(params[:page]).order(id: :desc)
  end

  def show
    @device = Device.find(params[:id])
    @saved_buttons_settings = []
    render "devices/show", layout: "application"
  end

  def procon_performance_metric
    @device = Device.find(params[:id])
    @user = @device.user
    @metrics = ProconPerformanceMetric::ReadService.new.execute(device_uuid: @device.uuid)
    visualize(metrics: @metrics)
    render "devices/procon_performance_metrics/show", layout: "application"
  end
end
