module ProconPerformanceMetric
  class ReadService < ProconPerformanceMetric::Base
    # @return [Array<ProconPerformanceMetricStruct>]
    def execute(device_uuid: )
      self.class.redis.lrange(device_uuid, 0, -1).map do |value|
        deserialize(value)
      end
    end
  end
end
