require 'rails_helper'

describe StreamingService::FetchChatMessagesService do
  let(:user) { FactoryBot.create(:user) }
  let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
  let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }
  let(:youtube_live_client) { double(:client) }

  describe 'execute' do

    subject { described_class.new(streaming_service_account, video_id: "foo").execute }

    before do
      allow(youtube_live_client).to receive(:video_id=)
      allow(youtube_live_client).to receive(:chat_id=)
      allow(youtube_live_client).to receive(:chat_messages) { ["token", []] }
      allow(StreamingService::YoutubeLiveClient).to receive(:new) { youtube_live_client }
      streaming_service_account.cached_data["video"] = { "value" => [1, 2, 3, 4, 5, 6] }
    end

    it 'page_tokenをcached_dataに保存すること' do
      expect { subject }.to change { streaming_service_account.cached_data["video"]["next_page_token"] }.from(nil).to("token")
    end

    it { expect(subject).to eq([]) }
  end
end
