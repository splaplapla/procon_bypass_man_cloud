module ProconPerformanceMetric
  class ProconPerformanceMetricStruct < Struct.new(:timestamp,
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
                                                   :succeed_rate,
                                                   :collected_spans_size)
    def time_taken_max
      super.to_f
    end

    def time_taken_p50
      super.to_f
    end

    def time_taken_p95
      super.to_f
    end

    def time_taken_p99
      super.to_f
    end

    def write_time_max
      super.to_f
    end

    def write_time_p50
      super.to_f
    end

    def read_time_max
      super.to_f
    end

    def read_time_p50
      super.to_f
    end

    def interval_from_previous_succeed_max
      super.to_f
    end

    def interval_from_previous_succeed_p50
      super.to_f
    end

    def read_error_count
      super.to_i
    end

    def write_error_count
      super.to_i
    end

    def succeed_rate
      super.to_f
    end

    def collected_spans_size
      super.to_i
    end

    def timestamp
      super.to_time
    end
  end


  class Base
    def self.redis
      redis = Redis.new(url: ENV['REDIS_URL'])
      Redis::Namespace.new(:procon_performance_metric, redis: redis)
    end

    private

    def serialize(*values)
      values.join(',')
    end

    def deserialize(value)
      ProconPerformanceMetricStruct.new(*value.split(','))
    end
  end
end
