class ProconPerformanceMetric::WriterService < ProconPerformanceMetric::Base
  # @return [void]
  def execute(timestamp: ,
              time_taken_max: ,
              time_taken_p50: ,
              time_taken_p99: ,
              time_taken_p95: ,
              read_error_count: ,
              write_error_count: ,
              load_agv: ,
              device_uuid: ,
             )

    value = serialize(timestamp, time_taken_max, time_taken_p50, time_taken_p99, time_taken_p95 , read_error_count, write_error_count, load_agv)
    self.class.redis.rpush(device_uuid, value)

    self.class.redis.ltrim(device_uuid, 0, max_stored_items_size)
    self.class.redis.expire(device_uuid, retention_period.to_i)
    value
  end

  private

  # 2時間
  def retention_period
    2.hours
  end

  # 毎分1個送られてくる想定で、2時間キープするのでせいぜい120だけ保存していればいいでしょう
  def max_stored_items_size
    120
  end
end
