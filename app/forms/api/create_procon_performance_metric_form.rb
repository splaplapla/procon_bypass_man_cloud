class Api::CreateProconPerformanceMetricForm
  include ActiveModel::Model

  attr_accessor \
    :timestamp,
    :time_taken_max,
    :time_taken_p50,
    :time_taken_p99,
    :time_taken_p95,
    :read_error_count,
    :write_error_count,
    :load_agv,
    :interval_from_previous_succeed_max,
    :interval_from_previous_succeed_p50,
    :external_input_time_max,
    :succeed_rate,
    :collected_spans_size,
    :write_time_max,
    :write_time_p50,
    :read_time_max,
    :read_time_p50,
    :gc_count,
    :gc_time

  validates :timestamp, :time_taken_max, :time_taken_p50, :time_taken_p99, :time_taken_p95, :read_error_count, :write_error_count, :load_agv, presence: true
end
