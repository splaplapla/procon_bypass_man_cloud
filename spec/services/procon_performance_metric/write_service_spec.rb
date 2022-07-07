require 'rails_helper'

describe ProconPerformanceMetric::WriteService do
  let(:redis) { MockRedis.new }
  let(:form) do
    OpenStruct.new(
      timestamp: "a",
      time_taken_max: 44,
      time_taken_p50: 50,
      time_taken_p95: 95,
      time_taken_p99: 99,
      read_error_count: 3,
      write_error_count: 5,
      load_agv: "2-2-2",
      device_uuid: "abc",
    )
  end

  before do
    allow(ProconPerformanceMetric::Base).to receive(:redis) { redis }
  end

  def run
    described_class.new.execute(
      timestamp: "2011-11-11 10:00:00+09:00",
      time_taken_max: form.time_taken_max,
      time_taken_p50: form.time_taken_p50,
      time_taken_p95: form.time_taken_p95,
      time_taken_p99: form.time_taken_p99,
      read_error_count: form.read_error_count,
      write_error_count: form.write_error_count,
      load_agv: form.load_agv,
      device_uuid: form.device_uuid,
    )
  end

  it '120個まで保存されること' do
    123.times do
      run
    end
    expect(ProconPerformanceMetric::Base.redis.lrange(form.device_uuid, 0, -1).size).to eq(120)
  end

  it '2時間まで保存されること' do
    Timecop.freeze(3.hours.ago) do
      run
      expect(ProconPerformanceMetric::Base.redis.lrange(form.device_uuid, 0, -1).size).to eq(1)
    end

    expect(ProconPerformanceMetric::Base.redis.lrange(form.device_uuid, 0, -1).size).to eq(0)
  end
end
