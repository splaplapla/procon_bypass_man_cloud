require 'rails_helper'

describe StreamingService::ShowAvailableLiveStreamService do
  describe '#execute' do
    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    let(:youtube_live_client) { double(:client) }

    subject { described_class.new(streaming_service_account).execute }

    before do
      allow(StreamingService::YoutubeLiveClient).to receive(:new) { youtube_live_client }
      allow(youtube_live_client).to receive(:my_channel_id) { "a" }
      allow(youtube_live_client).to receive(:available_live_stream) { "b" }
    end

    context 'cached_dataにmy_channel_idがあるとき' do
      before do
        streaming_service_account.update!(cached_data: { my_channel_id: "aa" })
      end

      it do
        expect { subject }.not_to change { streaming_service_account.cached_data["my_channel_id"] }
      end

      it do
        expect(subject).to eq(["aa", "b"])
      end
    end

    context 'cached_dataにmy_channel_idがないとき' do
      it do
        expect { subject }.to change { streaming_service_account.cached_data["my_channel_id"] }.from(nil).to("a")
      end

      it do
        expect(subject).to eq(["a", "b"])
      end
    end
  end
end
