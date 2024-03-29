require 'rails_helper'

RSpec.describe StreamingServicesController, type: :request do
  include_context "login_with_user"

  describe "GET /index" do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }

    before do
      streaming_service
    end

    it do
      get streaming_services_path
      expect(response).to be_ok
    end
  end

  describe "GET /new" do
    it do
      get new_streaming_service_path
      expect(response).to be_ok
    end
  end

  describe "POST #create" do
    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service_attribute) { FactoryBot.attributes_for(:streaming_service, ) }

    subject { post streaming_services_path, params: { streaming_service: { name: 'foo', service_type: service_type } } }

    context 'service_type is youtube_live' do
      let(:service_type) { :youtube_live }

      it do
        subject
        expect(response).to be_redirect
      end

      it { expect { subject }.to change { user.streaming_services.count }.by(1) }
    end

    context 'service_type is twitch' do
      let(:service_type) { :twitch }

      it do
        subject
        expect(response).to be_redirect
      end

      it { expect { subject }.to change { user.streaming_services.count }.by(1) }
    end
  end

  describe "GET #show" do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, service_type: service_type, device: device, user: user) }

    subject { get streaming_service_path(streaming_service) }

    describe 'service type is' do
      context 'youtube live' do
        let(:service_type) { StreamingService.service_types[:youtube_live] }

        it do
          subject
          expect(response).to be_ok
        end

        it do
          subject
          expect(response.body).to include('連携しているyoutubeチャンネル')
        end
      end

      context 'twitch' do
        let(:service_type) { StreamingService.service_types[:twitch] }

        it do
          subject
          expect(response).to be_ok
        end

        it do
          subject
          expect(response.body).to include('連携しているtwitchチャンネル')
        end
      end
    end
  end

  describe "GET /edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }

    it do
      get edit_streaming_service_path(streaming_service)
      expect(response).to be_ok
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { FactoryBot.create(:user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, user: user) }

    subject { delete streaming_service_path(streaming_service) }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      streaming_service
      expect { subject }.to change { user.streaming_services.count }.by(-1)
    end
  end

  describe 'DELETE #unlink_streaming_service_account' do
    let(:user) { FactoryBot.create(:user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { delete unlink_streaming_service_account_streaming_service_path(streaming_service) }

    before do
      streaming_service_account
    end

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { streaming_service.reload_streaming_service_account }.to(nil)
    end
  end
end
