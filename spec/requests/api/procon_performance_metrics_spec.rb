require 'rails_helper'

RSpec.describe Api::ProconPerformanceMetricsController, type: :request do
  let(:device) { FactoryBot.create(:device) }

  subject { post api_device_procon_performance_metrics_path(device.uuid), params: { body: body_params } }

  describe 'POST #create' do
    context 'param is valid' do
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

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(
          ProconPerformanceMetric::ReadService.new.execute(device_uuid: device.uuid).size
        ).to eq(1)
      end
    end

    context 'param is invalid' do
      let(:body_params) {
        {
          time_taken_max: 1,
          time_taken_p50: 2,
          time_taken_p99: 3,
          time_taken_p95: 3,
          read_error_count: 3,
          write_error_count: 3,
          load_agv: 2,
        }
      }

      it do
        subject
        expect(response).to be_bad_request
      end
    end
  end
end
