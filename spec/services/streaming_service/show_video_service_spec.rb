require 'rails_helper'

describe StreamingService::ShowVideoService do
  describe '#execute' do
    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    let(:youtube_live_client) { double(:client) }

    subject { described_class.new(streaming_service_account, video_id: "foo").execute }

    before do
      allow(StreamingService::YoutubeLiveClient).to receive(:new) { youtube_live_client }
      allow(youtube_live_client).to receive(:video_id=) { "a" }
      allow(youtube_live_client).to receive(:my_channel_id=) { "a" }
      allow(youtube_live_client).to receive(:video) { StreamingService::YoutubeLiveClient::Video.new(:a, :b, :c, :d, :e) }
      allow(youtube_live_client).to receive(:my_channel_id) { "a" }
      allow(youtube_live_client).to receive(:available_live_stream) { "b" }
    end

    context 'cached_dataに違うvideoがあるとき' do
      before do
        streaming_service_account.update!(cached_data: { video: {"id"=>"var", "value"=>["1", "2", "3", "4", "5"] } })
      end

      it do
        expect { subject }.to change { streaming_service_account.cached_data["video"] }
      end

      it do
        subject
        expect(streaming_service_account.cached_data["video"]).to eq({"id"=>"foo", "value"=>["a", "b", "c", "d", "e", nil] })
      end

      it do
        expect(subject.first).to eq("a")
      end

      it do
        expect(subject.to_h.values).to eq(["a", "b", "c", "d", "e", nil])
      end
    end

    context 'cached_dataに同じvideoがあるとき' do
      before do
        streaming_service_account.update!(cached_data: { video: {"id"=>"foo", "value"=>["a", "b", "c", "d", "e"] } })
      end

      it do
        expect { subject }.not_to change { streaming_service_account.cached_data["video"] }
      end
    end

    context 'cached_dataにvideoがないとき' do
      it do
        expect { subject }.to change { streaming_service_account.cached_data["video"] }
      end

      it do
        subject
        expect(streaming_service_account.cached_data["video"]).to eq({"id"=>"foo", "value"=>["a", "b", "c", "d", "e", nil] })
      end
    end

    context 'cached_dataにmy_channel_idがあるとき' do
      before do
        streaming_service_account.update!(cached_data: { my_channel_id: "aa" })
      end

      it do
        expect { subject }.not_to change { streaming_service_account.cached_data["my_channel_id"] }
      end

      it do
        expect(subject).to match(
          an_instance_of(StreamingService::YoutubeLiveClient::Video)
        )
      end
    end

    context 'cached_dataにmy_channel_idがないとき' do
      it do
        expect { subject }.to change { streaming_service_account.cached_data["my_channel_id"] }.from(nil).to("a")
      end

      it do
        expect(subject).to match(
          an_instance_of(StreamingService::YoutubeLiveClient::Video)
        )
      end
    end
  end
end
