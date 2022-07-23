class ProconPerformanceMetric::WriteService < ProconPerformanceMetric::Base
  # @return [void]
  def execute(timestamp: ,
              time_taken_max: ,
              time_taken_p50: ,
              time_taken_p95: ,
              time_taken_p99: ,
              write_time_max: ,
              write_time_p50: ,
              read_time_max: ,
              read_time_p50: ,
              interval_from_previous_succeed_max: ,
              interval_from_previous_succeed_p50: ,
              read_error_count: ,
              write_error_count: ,
              load_agv: ,
              device_uuid: ,
              succeed_rate: ,
              collected_spans_size: )

    # NOTE 毎分1個送られてくる想定. 2時間保存期間であれば、120個を上限で保存する
    user = Device.eager_load(:user).find_by(uuid: device_uuid)&.user
    performance_metrics_retention_hours = user&.performance_metrics_retention_hours || minimum_performance_metrics_retention_hours
    max_stored_items_size = 60 * performance_metrics_retention_hours

    value = serialize(timestamp,
                      time_taken_max,
                      time_taken_p50,
                      time_taken_p95,
                      time_taken_p99,
                      write_time_max,
                      write_time_p50,
                      read_time_max,
                      read_time_p50,
                      interval_from_previous_succeed_max,
                      interval_from_previous_succeed_p50,
                      read_error_count,
                      write_error_count,
                      load_agv,
                      succeed_rate,
                      collected_spans_size)

    self.class.redis.rpush(device_uuid, value)
    # NOTE 保存上限が小さくなった時に上限まで消す
    loop do
      if self.class.redis.llen(device_uuid) > max_stored_items_size
        self.class.redis.lpop(device_uuid)
      else
        break
      end
    end
    self.class.redis.expire(device_uuid, performance_metrics_retention_hours.hours.to_i)
    value
  end

  private

  def minimum_performance_metrics_retention_hours
    UserPlan::DETAIL[UserPlan::PLAN::PLAN_FREE][UserPlan::CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS]
  end
end
