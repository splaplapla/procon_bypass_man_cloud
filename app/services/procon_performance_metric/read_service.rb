class ProconPerformanceMetric::ReadService < ProconPerformanceMetric::Base
  # @return [Array<ProconPerformanceMetricStruct>]
  def execute(device_uuid: )
    self.class.redis.lrange(device_uuid, 0, -1).map { |value|
      deserialize(value)
    }.compact # redisへの格納フォーマットを変更したので一定期間はjsonパーズエラーが起きてnilを返す
  end

  private

  def deserialize(value)
    hash = JSON.parse(value).with_indifferent_access
    ::ProconPerformanceMetric::ProconPerformanceMetricStruct.new(
      hash[:timestamp],
      hash[:time_taken_max],
      hash[:time_taken_p50],
      hash[:time_taken_p95],
      hash[:time_taken_p99],
      hash[:write_time_max],
      hash[:write_time_p50],
      hash[:read_time_max],
      hash[:read_time_p50],
      hash[:interval_from_previous_succeed_max],
      hash[:interval_from_previous_succeed_p50],
      hash[:external_input_time_max],
      hash[:read_error_count],
      hash[:write_error_count],
      hash[:load_agv],
      hash[:gc_count],
      hash[:gc_time],
      hash[:succeed_rate],
      hash[:collected_spans_size],
    )
  rescue JSON::ParserError
    nil
  end
end
