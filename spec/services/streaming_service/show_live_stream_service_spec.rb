require 'rails_helper'

describe StreamingService::ShowLiveStreamService do
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
      allow(youtube_live_client).to receive(:active_streaming_video) { StreamingService::YoutubeLive::Video.new(:a, :b, :c, :d, :e) }
      allow(youtube_live_client).to receive(:my_channel_id) { "a" }
      allow(youtube_live_client).to receive(:available_live_stream) { "b" }
    end

    context 'ライブ配信ではない、とき' do
      context 'ライブ配信ではない状態が記録済みのとき' do
        before do
          streaming_service_account.update!(cached_data: { video: {"id"=>"foo", "value"=>["foo", "2", "3", "4", "5"] } })
          StreamingService::YoutubeLiveDecorator.new(streaming_service_account).video_is_not_live
          streaming_service_account.save!
        end

        it do
          expect { subject }.to raise_error(StreamingService::ShowLiveStreamService::AvailableVideoNotError)
        end

        it do
          expect {
            begin
              subject
            rescue
              # no-op
            end
          }.not_to(change { StreamingService::YoutubeLiveDecorator.new(streaming_service_account).video_is_live? })
        end
      end

      context 'キャッシュにないvideo_idがライブ配信ではないとき' do
        before do
          streaming_service_account.update!(cached_data: { video: {"id"=>"foo", "value"=>["var", "2", "3", "4", "5"] } })
          expect(youtube_live_client).to receive(:active_streaming_video) { raise StreamingService::YoutubeLiveClient::NotLiveStreamError }
        end

        it do
          expect { subject }.to raise_error(StreamingService::ShowLiveStreamService::AvailableVideoNotError)
        end

        it do
          expect {
            begin
              subject
            rescue
              # no-op
            end
          }.to change { StreamingService::YoutubeLiveDecorator.new(streaming_service_account).video_is_live? }.from(false).to(true)
        end
      end
    end

    context 'cached_dataに違うvideoがあるとき' do
      before do
        streaming_service_account.update!(cached_data: { video: {"id"=>"var", "value"=>["1", "2", "3", "4", "5"] } })
      end

      it do
        expect { subject }.to(change { streaming_service_account.cached_data["video"] })
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
        streaming_service_account.update!(cached_data: { video: {"id"=>"foo", "value"=>["a", "b", "c", "d", "e", nil] } })
      end

      it do
        expect { subject }.not_to(change { streaming_service_account.cached_data["video"] })
      end
    end

    context 'cached_dataにvideoがないとき' do
      it do
        expect { subject }.to(change { streaming_service_account.cached_data["video"] })
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
        expect { subject }.not_to(change { streaming_service_account.cached_data["my_channel_id"] })
      end

      it do
        expect(subject).to match(
          an_instance_of(StreamingService::YoutubeLive::Video)
        )
      end
    end

    context 'cached_dataにmy_channel_idがないとき' do
      it do
        expect { subject }.to change { streaming_service_account.cached_data["my_channel_id"] }.from(nil).to("a")
      end

      it do
        expect(subject).to match(
          an_instance_of(StreamingService::YoutubeLive::Video)
        )
      end
    end
  end
end
