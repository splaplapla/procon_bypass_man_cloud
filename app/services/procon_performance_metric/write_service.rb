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
    if self.class.redis.llen(device_uuid) > max_stored_items_size
      self.class.redis.lpop(device_uuid)
    end
    self.class.redis.expire(device_uuid, retention_period.hours.to_i)
    value
  end

  private

  def retention_period
    10
  end

  # 毎分1個送られてくる想定で、2時間キープするのでせいぜい120だけ保存していればいいでしょう
  def max_stored_items_size
    retention_period * 60
  end
end
