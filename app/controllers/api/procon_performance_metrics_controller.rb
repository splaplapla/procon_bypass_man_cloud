class Api::ProconPerformanceMetricsController < Api::Base
  def create
    device = get_device

    form = Api::CreateProconPerformanceMetricForm.new(metric_params)
    form.validate!

    ProconPerformanceMetric::WriteService.new.execute(
      timestamp: form.timestamp,
      time_taken_max: form.time_taken_max,
      time_taken_p50: form.time_taken_p50,
      time_taken_p95: form.time_taken_p95,
      time_taken_p99: form.time_taken_p99,
      read_error_count: form.read_error_count,
      write_error_count: form.write_error_count,
      load_agv: form.load_agv,
      device_uuid: device.uuid,
    )

    render json: {}, status: :ok
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end

  private

  def metric_params
    params.require(:body).permit(
      :timestamp,
      :time_taken_max,
      :time_taken_p50,
      :time_taken_p95,
      :time_taken_p99,
      :read_error_count,
      :write_error_count,
      :load_agv,
    )
  end
end
