require 'rails_helper'

describe StreamingService::YoutubeLiveClient do
  describe '#available_live_stream' do
    let(:client) { described_class.new(streaming_service_account) }

    subject { client.available_live_stream }

    context 'レスポンスが入っていないとき' do
      let(:user) { FactoryBot.create(:user) }
      let(:device) { FactoryBot.create(:device, user: user) }
      let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
      let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }
      let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

      before do
        allow(client).to receive(:my_channel_id) { "foo" }
        allow(StreamingService::YoutubeLiveClient::AvailableLiveStreamRequest).to receive(:request) do
          OpenStruct.new(
            code: '200',
            body: {
              "kind"=>"youtube#searchListResponse",
              "etag"=>"WeZpW4nj1d4IqYnWsCVHsjGXP0U",
              "regionCode"=>"JP",
              "pageInfo"=>{"totalResults"=>1, "resultsPerPage"=>1},
              "items"=> [],
            }.to_json
          )
        end
      end

      it { expect(subject).to be_nil }
    end

    context 'レスポンスが入っているとき' do
      let(:user) { FactoryBot.create(:user) }
      let(:device) { FactoryBot.create(:device, user: user) }
      let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
      let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }
      let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

      before do
        allow(client).to receive(:my_channel_id) { "foo" }
        allow(StreamingService::YoutubeLiveClient::AvailableLiveStreamRequest).to receive(:request) do
          OpenStruct.new(
            code: '200',
            body: {
              "kind"=>"youtube#searchListResponse",
              "etag"=>"WeZpW4nj1d4IqYnWsCVHsjGXP0U",
              "regionCode"=>"JP",
              "pageInfo"=>{"totalResults"=>1, "resultsPerPage"=>1},
              "items"=> [
                { "kind"=>"youtube#searchResult",
                  "etag"=>"5clO97Y4usNaKqnLj6lwIcnt3YM",
                  "id"=>{"kind"=>"youtube#video", "videoId"=>"oBDMO5ehSWM"},
                  "snippet"=> {
                    "publishedAt"=>"2022-03-20T04:08:09Z",
                    "channelId"=>"UCDnRs0X-12Aa_NzeX8KhbDg",
                    "title"=>"テスト",
                    "description"=>"https://github.com/splaplapla/procon_bypass_man を使っています 使用中の設定は  です ...",
                    "thumbnails"=> {
                      "default"=>{"url"=>"https://i.ytimg.com/vi/oBDMO5ehSWM/default_live.jpg", "width"=>120, "height"=>90},
                      "medium"=>{"url"=>"https://i.ytimg.com/vi/oBDMO5ehSWM/mqdefault_live.jpg", "width"=>320, "height"=>180},
                      "high"=>{"url"=>"https://i.ytimg.com/vi/oBDMO5ehSWM/hqdefault_live.jpg", "width"=>480, "height"=>360}
                    },
                    "channelTitle"=>"スプラトゥーン2をやっていく猫",
                    "liveBroadcastContent"=>"live",
                    "publishTime"=>"2022-03-20T04:08:09Z",
                  }
                }
              ]
            }.to_json
          )
        end
      end

      it { expect(subject.id).to eq("oBDMO5ehSWM") }
      it { expect(subject.published_at).to eq("2022-03-20 04:08:09 +0000".to_time) }
      it { expect(subject.title).to eq("テスト") }
      it { expect(subject.description).to eq("https://github.com/splaplapla/procon_bypass_man を使っています 使用中の設定は  です ...") }
      it { expect(subject.thumbnails_high_url).to eq("https://i.ytimg.com/vi/oBDMO5ehSWM/hqdefault_live.jpg") }
    end
  end
end
