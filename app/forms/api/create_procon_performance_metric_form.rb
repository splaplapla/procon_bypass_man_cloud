class Api::CreateProconPerformanceMetricForm
  include ActiveModel::Model

  attr_accessor :timestamp, :time_taken_max, :time_taken_p50, :time_taken_p99, :time_taken_p95, :read_error_count, :write_error_count, :load_agv, :interval_from_previous_succeed_max, :interval_from_previous_succeed_p50, :succeed_rate, :collected_spans_size

  validates :timestamp, :time_taken_max, :time_taken_p50, :time_taken_p99, :time_taken_p95, :read_error_count, :write_error_count, :load_agv, presence: true
end
