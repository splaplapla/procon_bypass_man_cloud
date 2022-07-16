require 'rails_helper'

RSpec.describe Devices::ProconPerformanceMetricsController, type: :request do
  include_context "login_with_user"

  describe 'GET #index' do
    let(:device) { FactoryBot.create(:device, user: user) }

    subject { get device_procon_performance_metric_path(device.unique_key) }

    it do
      subject
      expect(response).to be_ok
    end
  end
end
