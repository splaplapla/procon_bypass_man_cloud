require 'rails_helper'

describe ProconPerformanceMetric::ReadService do
  include_context "redis_mock"

  let(:device_uuid) { "abc" }

  before do
    ProconPerformanceMetric::WriteService.new.execute(
      timestamp: "2011-11-11 10:00:00+09:00",
      time_taken_max: 22,
      time_taken_p50: 24,
      time_taken_p95: 3,
      time_taken_p99: 4,
      read_error_count: 5,
      write_error_count: 6,
      load_agv: "2-3-3",
      device_uuid: device_uuid,
    )
    ProconPerformanceMetric::WriteService.new.execute(
      timestamp: "2011-11-11 10:01:00+09:00",
      time_taken_max: 11,
      time_taken_p50: 22,
      time_taken_p95: 33,
      time_taken_p99: 44,
      read_error_count: 55,
      write_error_count: 6,
      load_agv: "3-3-3",
      device_uuid: device_uuid,
    )
  end

  subject { described_class.new.execute(device_uuid: device_uuid) }

  it do
    metric1, metric2 = subject
    expect(metric1.time_taken_max).to eq(22)
    expect(metric1.time_taken_p50).to eq(24)
    expect(metric1.time_taken_p95).to eq(3)
    expect(metric1.time_taken_p99).to eq(4)
    expect(metric1.read_error_count).to eq(5)
    expect(metric1.write_error_count).to eq(6)

    expect(metric2.time_taken_max).to eq(11)
    expect(metric2.time_taken_p50).to eq(22)
    expect(metric2.time_taken_p95).to eq(33)
    expect(metric2.time_taken_p99).to eq(44)
    expect(metric2.read_error_count).to eq(55)
    expect(metric2.write_error_count).to eq(6)
  end
end
