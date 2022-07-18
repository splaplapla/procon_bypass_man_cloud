require 'rails_helper'

RSpec.describe "Demo", type: :request do
  describe "GET #show" do
    subject { get demo_path }

    context 'デモデバイスがあるとき' do
      let(:device) { FactoryBot.create(:device) }

      before do
        device.create_demo_device!
      end

      it do
        subject
        expect(response).to be_ok
      end
    end

    context 'デモデバイスがないとき' do
      it do
        subject
        expect(response).to be_redirect
      end

      context 'ログインユーザで表示するとき' do
        include_context "login_with_admin_user"

        it do
          subject
          expect(response).to be_redirect
        end

        it do
          expect { subject }.not_to change { session[:user_id] }
        end
      end
    end
  end

  describe "GET #procon_performance_metric" do
    subject { get procon_performance_metric_demo_path }

    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }

    before do
      device.create_demo_device!

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
        load_agv: "3-3-3",
        device_uuid: device.uuid,
        succeed_rate: 0.9,
        collected_spans_size: 300,
      )
    end

    it do
      subject
      expect(response).to be_ok
    end
  end
end
