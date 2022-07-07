class Api::CreateProconPerformanceMetricForm
  include ActiveModel::Model

  attr_accessor :timestamp, :time_taken_max, :time_taken_p50, :time_taken_p99, :time_taken_p95, :read_error_count, :write_error_count, :load_agv

  validates :timestamp, :time_taken_max, :time_taken_p50, :time_taken_p99, :time_taken_p95, :read_error_count, :write_error_count, :load_agv, presence: true
end
