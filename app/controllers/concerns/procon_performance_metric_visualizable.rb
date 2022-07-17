module ProconPerformanceMetricVisualizable
  def visualize(metrics: )
    @read_time_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.read_time_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.read_time_p50] }, name: '中央値' },
      ]
    @write_time_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.write_time_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.write_time_p50] }, name: '中央値' },
    ]
    @read_write_time_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.time_taken_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p50] }, name: '中央値' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p95] }, name: 'P95' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p99] }, name: 'P99' },
    ]
    @bypass_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.interval_from_previous_succeed_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.interval_from_previous_succeed_p50] }, name: '中央値' },
    ]
    @bypass_count_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.collected_spans_size] }, name: '合計' },
    ]
  end
end
