class Api::ProconPerformanceMetricsController < Api::Base
  def create
    device = get_device

    form = Api::CreateProconPerformanceMetricForm.new(metric_params)
    form.validate!

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
      :time_taken_p99,
      :time_taken_p95,
      :read_error_count,
      :write_error_count,
      :load_agv,
    )
  end
end
