require 'rails_helper'

RSpec.describe StreamingServices::MonitoringsController, type: :request do
  describe 'POST #post' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { post streaming_service_streaming_service_account_monitoring_path(streaming_service, streaming_service_account) }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { streaming_service_account.reload.monitors_at }.from(nil)
    end
  end

  describe 'POST #destroy' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { delete streaming_service_streaming_service_account_monitoring_path(streaming_service, streaming_service_account) }

    before do
      streaming_service_account.update!(monitors_at: Time.zone.now)
    end

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { streaming_service_account.reload.monitors_at }.to(nil)
    end
  end
end
