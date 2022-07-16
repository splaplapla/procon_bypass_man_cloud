require 'rails_helper'

RSpec.describe StreamingServices::YoutubeLiveController, type: :request do
  describe 'GET #new' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    let(:service_double) { double(:service) }

    subject { get new_streaming_service_youtube_live_path(streaming_service) }

    before do
      streaming_service_account
      allow(StreamingService::ShowAvailableLiveStreamService).to receive(:new) { service_double }
    end

    context '配信中のライブがあるとき' do
      let(:live_video) { double(:live).as_null_object }
      before do
        allow(live_video).to receive(:thumbnails_high_url) { "/" }
        allow(live_video).to receive(:published_at) { Time.zone.now }
        allow(service_double).to receive(:execute) { ["bar", live_video] }
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
        allow(service_double).to receive(:execute) { ["bar", nil] }
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
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }
    let(:live_video) { double(:live).as_null_object }

    let(:service_double) { double(:service) }

    subject { get streaming_service_youtube_live_path(streaming_service, "foo") }

    before do
      streaming_service_account
      allow(live_video).to receive(:thumbnails_high_url) { "/" }
      allow(live_video).to receive(:published_at) { Time.zone.now }
      allow(service_double).to receive(:execute) { live_video }
      allow(StreamingService::ShowLiveStreamService).to receive(:new) { service_double }
    end

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'POST #commands' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { post commands_streaming_service_youtube_live_path(streaming_service, "foo") }

    before do
      streaming_service_account
    end

    context 'monitors_atがnil' do
      it do
        subject
        expect(response).to be_bad_request
      end
    end

    context 'monitors_atがnot nil' do
      before do
        service = double(:service).as_null_object
        allow(service).to receive(:execute) { {} }
        streaming_service_account.update!(monitors_at: Time.zone.now)
        allow(StreamingService::FetchChatMessagesService).to receive(:new) { service }
        allow(StreamingService::ConvertMessagesToCommandsService).to receive(:new) { service }
      end

      it do
        subject
        expect(response).to be_ok
      end
    end

    context 'StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaErrorが起きるとき' do
      before do
        allow(StreamingService::FetchChatMessagesService).to receive(:new) { raise StreamingService::YoutubeLiveClient::ExceededYoutubeQuotaError }
        streaming_service_account.update!(monitors_at: Time.zone.now)
      end

      it do
        subject
        expect(response).to be_server_error
      end

      it do
        subject
        expect(JSON.parse(response.body)).to eq("errors"=>["youtube APIのレートリミットに達しました。時間を空けて再度試してください。"])
      end
    end

    context 'StreamingService::YoutubeLiveClient::LiveChatRateLimitErrorが起きるとき' do
      before do
        allow(StreamingService::FetchChatMessagesService).to receive(:new) { raise StreamingService::YoutubeLiveClient::LiveChatRateLimitError }
        streaming_service_account.update!(monitors_at: Time.zone.now)
      end

      it do
        subject
        expect(response).to be_bad_request
      end

      it do
        subject
        expect(JSON.parse(response.body)).to eq("errors"=>["メッセージの取得頻度が早すぎます。"])
      end
    end

    context 'StreamingService::YoutubeLiveClient::ExpiredRefreshTokenErrorが起きるとき' do
      before do
        allow(StreamingService::FetchChatMessagesService).to receive(:new) { raise StreamingService::YoutubeLiveClient::ExpiredRefreshTokenError }
        streaming_service_account.update!(monitors_at: Time.zone.now)
      end

      it do
        subject
        expect(response).to be_bad_request
      end

      it do
        subject
        expect(response.body).to eq("アクセストークンが無効になりました。youtubeのアカウントを再連携をしてください。")
      end
    end
  end
end
