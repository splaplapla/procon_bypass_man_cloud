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
      write_time_max: form.write_time_max,
      write_time_p50: form.write_time_p50,
      read_time_max: form.read_time_max,
      read_time_p50: form.read_time_p50,
      interval_from_previous_succeed_max: form.interval_from_previous_succeed_max,
      interval_from_previous_succeed_p50: form.interval_from_previous_succeed_p50,
      read_error_count: form.read_error_count,
      write_error_count: form.write_error_count,
      load_agv: form.load_agv,
      gc_count: form.gc_count,
      device_uuid: device.uuid,
      succeed_rate: form.succeed_rate,
      collected_spans_size: form.collected_spans_size,
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
      :write_time_max,
      :write_time_p50,
      :read_time_max,
      :read_time_p50,
      :interval_from_previous_succeed_max,
      :interval_from_previous_succeed_p50,
      :read_error_count,
      :write_error_count,
      :load_agv,
      :gc_count,
      :succeed_rate,
      :collected_spans_size,
    )
  end
end
