require 'rails_helper'

RSpec.describe Api::ProconPerformanceMetricsController, type: :request do
  let(:device) { FactoryBot.create(:device) }

  describe 'POST #create' do
    let(:body_params) {
      {
        timestamp: 'a',
        time_taken_max: 1,
        time_taken_p50: 2,
        time_taken_p99: 3,
        time_taken_p95: 3,
        read_error_count: 3,
        write_error_count: 3,
        load_agv: 2,
      }
    }
    subject { post api_device_procon_performance_metrics_path(device.uuid), params: { body: body_params } }

    it do
      subject
      expect(response).to be_ok
    end
  end
end
