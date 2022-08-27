require 'rails_helper'

RSpec.describe Devices::ProconPerformanceMetricsController, type: :request do
  include_context "login_with_user"

  describe 'GET #index' do
    let(:device) { FactoryBot.create(:device, user: user) }

    subject { get device_procon_performance_metric_path(device.unique_key) }

    before do
      ProconPerformanceMetric::WriteService.new.execute(
        timestamp: "2022-07-16 12:23:00+09:00",
        time_taken_max: "0.168",
        time_taken_p50: "0.015",
        time_taken_p95: "0.016",
        time_taken_p99: "00.24",
        write_time_max: "0.168",
        write_time_p50: "0.001",
        read_time_max: "0.168",
        read_time_p50: "0.012",
        interval_from_previous_succeed_max: "0.168",
        interval_from_previous_succeed_p50: "0.015",
        read_error_count: "0",
        write_error_count: "491",
        load_agv: "0.49-0.5-0.55",
        gc_count: 3,
        gc_time: 3,
        device_uuid: 'd1',
        succeed_rate: 1,
        collected_spans_size: 4422,
      )
    end

    it do
      subject
      expect(response).to be_ok
    end
  end
end
