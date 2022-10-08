class Admin::DevicesController < Admin::Base
  include ProconPerformanceMetricVisualizable

  def index
    @devices = Device.all.page(params[:page]).order(id: :desc)
  end

  def show
    @device = Device.find(params[:id])
    if @device.user
      @saved_buttons_settings = @device.user.saved_buttons_settings.order(id: :asc)
    else
      @saved_buttons_settings = []
    end
    @latest_loading_config_event = @device.latest_loading_config_event
    @current_pbm_session = @device.current_device_status&.pbm_session
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
