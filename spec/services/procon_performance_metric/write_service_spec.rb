require 'rails_helper'

describe ProconPerformanceMetric::WriteService do
  let(:form) do
    OpenStruct.new(
      timestamp: "a",
      time_taken_max: 44,
      time_taken_p50: 50,
      time_taken_p95: 95,
      time_taken_p99: 99,
      write_time_max: 0.1,
      write_time_p50: 0.1,
      read_time_max: 0.2,
      read_time_p50: 0.2,
      interval_from_previous_succeed_max: 1,
      interval_from_previous_succeed_p50: 2,
      external_input_time_max: 1,
      read_error_count: 3,
      write_error_count: 5,
      load_agv: "2-2-2",
      gc_count: 3,
      gc_time: 3,
      device_uuid: "abc",
    )
  end

  def run
    described_class.new.execute(
      timestamp: "2011-11-11 10:00:00+09:00",
      time_taken_max: form.time_taken_max,
      time_taken_p50: form.time_taken_p50,
      time_taken_p95: form.time_taken_p95,
      time_taken_p99: form.time_taken_p99,
      write_time_max: form.write_time_max,
      write_time_p50: form.write_time_p50,
      read_time_max: form.read_time_max,
      read_time_p50: form.read_time_p50,
      interval_from_previous_succeed_max: form.interval_from_previous_succeed_max,
      interval_from_previous_succeed_p50: form.interval_from_previous_succeed_p50,
      external_input_time_max: 1,
      read_error_count: form.read_error_count,
      write_error_count: form.write_error_count,
      load_agv: form.load_agv,
      gc_count: form.gc_count,
      gc_time: form.gc_time,
      device_uuid: form.device_uuid,
      succeed_rate: 0.9,
      collected_spans_size: 400,
    )
  end

  context 'free' do
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

  context 'not free' do
    let(:device) { FactoryBot.create(:device, user: user, uuid: form.device_uuid) }
    let(:user) { FactoryBot.create(:user, plan: UserPlan::PLAN::PLAN_PRO) }

    before do
      device
    end

    it '120個まで保存されること' do
      123.times do
        run
      end
      expect(ProconPerformanceMetric::Base.redis.lrange(form.device_uuid, 0, -1).size).to eq(123)
    end

    it '2時間まで保存されること' do
      Timecop.freeze(3.hours.ago) do
        run
        expect(ProconPerformanceMetric::Base.redis.lrange(form.device_uuid, 0, -1).size).to eq(1)
      end

      expect(ProconPerformanceMetric::Base.redis.lrange(form.device_uuid, 0, -1).size).to eq(1)
    end
  end
end
