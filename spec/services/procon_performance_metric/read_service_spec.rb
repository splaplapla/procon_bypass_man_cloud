require 'rails_helper'

describe ProconPerformanceMetric::ReadService do
  let(:device_uuid) { "abc" }

  before do
    ProconPerformanceMetric::Base.redis.flushdb
    ProconPerformanceMetric::WriteService.new.execute(
      timestamp: "2011-11-11 10:00:00+09:00",
      time_taken_max: 22,
      time_taken_p50: 24,
      time_taken_p95: 3,
      time_taken_p99: 4,
      write_time_max: 0.1,
      write_time_p50: 0.1,
      read_time_max: 0.2,
      read_time_p50: 0.2,
      interval_from_previous_succeed_max: 1,
      interval_from_previous_succeed_p50: 2,
      read_error_count: 5,
      write_error_count: 6,
      load_agv: "2-3-3",
      gc_count: 3,
      gc_time: 3,
      device_uuid: device_uuid,
      succeed_rate: 0.9,
      collected_spans_size: 300,
    )
    ProconPerformanceMetric::WriteService.new.execute(
      timestamp: "2011-11-11 10:01:00+09:00",
      time_taken_max: 11,
      time_taken_p50: 22,
      time_taken_p95: 33,
      time_taken_p99: 44,
      write_time_max: 0.1,
      write_time_p50: 0.1,
      read_time_max: 0.2,
      read_time_p50: 0.2,
      interval_from_previous_succeed_max: 1,
      interval_from_previous_succeed_p50: 2,
      read_error_count: 55,
      write_error_count: 6,
      load_agv: "3.2-3-3",
      gc_count: 3,
      gc_time: 3,
      device_uuid: device_uuid,
      succeed_rate: 0.9,
      collected_spans_size: 300,
    )
  end

  subject { described_class.new.execute(device_uuid: device_uuid) }

  it do
    metric1, metric2 = subject
    expect(metric1.time_taken_max).to eq(22)
    expect(metric1.time_taken_p50).to eq(24)
    expect(metric1.time_taken_p95).to eq(3)
    expect(metric1.time_taken_p99).to eq(4)
    expect(metric1.interval_from_previous_succeed_max).to eq(1)
    expect(metric1.interval_from_previous_succeed_p50).to eq(2)
    expect(metric1.read_error_count).to eq(5)
    expect(metric1.write_error_count).to eq(6)
    expect(metric1.succeed_rate).to eq(0.9)
    expect(metric1.collected_spans_size).to eq(300)
    expect(metric1.write_time_max).to eq(0.1)
    expect(metric1.write_time_p50).to eq(0.1)
    expect(metric1.read_time_max).to eq(0.2)
    expect(metric1.read_time_p50).to eq(0.2)
    expect(metric1.load_agv).to eq([2.0, 3.0, 3.0])

    expect(metric2.time_taken_max).to eq(11)
    expect(metric2.time_taken_p50).to eq(22)
    expect(metric2.time_taken_p95).to eq(33)
    expect(metric2.time_taken_p99).to eq(44)
    expect(metric1.interval_from_previous_succeed_max).to eq(1)
    expect(metric1.interval_from_previous_succeed_p50).to eq(2)
    expect(metric2.read_error_count).to eq(55)
    expect(metric2.write_error_count).to eq(6)
    expect(metric2.succeed_rate).to eq(0.9)
    expect(metric2.collected_spans_size).to eq(300)
    expect(metric2.load_agv).to eq([3.2, 3.0, 3.0])
    expect(metric2.gc_count).to eq(3)
    expect(metric2.gc_time).to eq(3)
  end
end
