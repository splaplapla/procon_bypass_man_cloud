require 'rails_helper'

RSpec.describe StreamingServices::TwitchController, type: :request do
  describe 'GET #new' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { get new_streaming_service_twitch_path(streaming_service) }

    before do
      streaming_service_account
    end

    context '配信中のライブがあるとき' do
      let(:live_video) { double(:live).as_null_object }
      let(:client) { double(:client) }

      before do
        allow(live_video).to receive(:thumbnail_url) { "/" }
        allow(live_video).to receive(:started_at) { Time.zone.now }
        allow(client).to receive(:myself_live)  { live_video }
        allow(StreamingService::TwitchClient).to receive(:new) { client }
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to include("配信中のライブが見つかりました。")
      end
    end

    context '配信中のライブがないとき' do
      before do
        client = double(:client)
        allow(client).to receive(:myself_live)
        allow(StreamingService::TwitchClient).to receive(:new) { client }
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to include("配信中のライブが見つかりません")
      end
    end
  end

  describe 'GET #show' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user, remote_macro_group: remote_macro_group) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:live_video) { double(:live).as_null_object }
    let(:client) { double(:client) }

    subject { get streaming_service_twitch_path(streaming_service, "foo") }

    before do
      streaming_service_account

      allow(live_video).to receive(:thumbnail_url) { "/" }
      allow(live_video).to receive(:started_at) { Time.zone.now }
      allow(client).to receive(:myself)  { double(:user).as_null_object }
      allow(client).to receive(:myself_live)  { live_video }
      allow(StreamingService::TwitchClient).to receive(:new) { client }
    end

    it do
      subject
      expect(response).to be_ok
    end
  end
end
