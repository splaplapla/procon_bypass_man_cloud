require 'rails_helper'

describe StreamingService::YoutubeLiveClient do
  describe '#active_streaming_video' do
    let(:client) { described_class.new(streaming_service_account) }
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { client.active_streaming_video }

    context '配信が見つからなかったとき' do
      before do
        allow(client).to receive(:my_channel_id) { "foo" }
        allow(StreamingService::YoutubeLiveClient::LiveStreamDetailRequest).to receive(:request) do
          OpenStruct.new(
            code: '200',
            body: {
              "kind"=>"youtube#videoListResponse",
              "etag"=>"TKGl1LDXcI8VcOBvBt0DiSIrfe0",
              "items"=>[],
              "pageInfo"=>{"totalResults"=>1, "resultsPerPage"=>1},
            }.to_json
          )
        end
        client.video_id = "foo"
      end

      it { expect { subject }.to raise_error(StreamingService::YoutubeLiveClient::VideoNotFoundError) }
    end

    context '別チャンネルの動画のとき' do
      before do
        allow(client).to receive(:my_channel_id) { "foo" }
        allow(StreamingService::YoutubeLiveClient::LiveStreamDetailRequest).to receive(:request) do
          OpenStruct.new(
            code: '200',
            body: {
              "kind"=>"youtube#videoListResponse",
              "etag"=>"T",
              "items"=>[
                { "snippet" => { "channelId" => "abv" },
                  "liveStreamingDetails" => { "activeLiveChatId" => "foo" }
                }
              ],
              "pageInfo"=>{"totalResults"=>1, "resultsPerPage"=>1},
            }.to_json
          )
        end
        client.video_id = "foo"
      end

      it { expect { subject }.to raise_error(StreamingService::YoutubeLiveClient::NotOwnerVideoError) }
    end

    context '配信が終了した動画のとき' do
      before do
        allow(client).to receive(:my_channel_id) { "foo" }
        allow(StreamingService::YoutubeLiveClient::LiveStreamDetailRequest).to receive(:request) do
          OpenStruct.new(
            code: '200',
            body: {
              "kind"=>"youtube#videoListResponse",
              "etag"=>"TKGl1LDXcI8VcOBvBt0DiSIrfe0",
              "items"=>[
                { "snippet" => { "channelId" => "abv" },
                  "liveStreamingDetails" => { "activeLiveChatId" => nil }
                }
              ],
              "pageInfo"=>{"totalResults"=>1, "resultsPerPage"=>1},
            }.to_json
          )
        end
        client.video_id = "foo"
      end

      it { expect { subject }.to raise_error(StreamingService::YoutubeLiveClient::NotLiveStreamError) }
    end

    context '有効な配信が見つかったとき' do
      let(:my_channel_id) { "foo" }
      before do
        allow(StreamingService::YoutubeLiveClient::LiveStreamDetailRequest).to receive(:request) do
          OpenStruct.new(
            code: '200',
            body: {
              "kind"=>"youtube#videoListResponse",
              "etag"=>"TKGl1LDXcI8VcOBvBt0DiSIrfe0",
              "items"=> [
                { "kind"=>"youtube#video",
                  "etag"=>"vpC4MoKGqV8eqtTuoN1aWNXKeDM",
                  "id"=>"eU3QvsjEH18",
                  "snippet"=> {
                    "publishedAt"=>"2022-03-21T07:21:17Z",
                    "channelId" => my_channel_id,
                    "title"=>"テスト",
                    "description"=>"https://github.com/splaplapla/procon_bypass_man を使っています\n\n使用中の設定は👇です\nhttps://pbm-cloud.herokuapp.com/p/bc059b14-662a-431a-b310-7949435dbdc3",
                    "thumbnails"=> {
                      "default"=>{"url"=>"https://i.ytimg.com/vi/eU3QvsjEH18/default_live.jpg", "width"=>120, "height"=>90},
                      "medium"=>{"url"=>"https://i.ytimg.com/vi/eU3QvsjEH18/mqdefault_live.jpg", "width"=>320, "height"=>180},
                      "high"=>{"url"=>"https://i.ytimg.com/vi/eU3QvsjEH18/hqdefault_live.jpg", "width"=>480, "height"=>360},
                      "standard"=>{"url"=>"https://i.ytimg.com/vi/eU3QvsjEH18/sddefault_live.jpg", "width"=>640, "height"=>480},
                      "maxres"=>{"url"=>"https://i.ytimg.com/vi/eU3QvsjEH18/maxresdefault_live.jpg", "width"=>1280, "height"=>720}},
                    "channelTitle"=>"スプラトゥーン2をやっていく猫",
                    "tags"=>["スプラトゥーン2", "ガチマッチ"],
                    "categoryId"=>"20",
                    "liveBroadcastContent"=>"live",
                    "localized"=> {
                      "title"=>"テスト", "description"=>"https://github.com/splaplapla/procon_bypass_man を使っています\n\n使用中の設定は👇です\nhttps://pbm-cloud.herokuapp.com/p/bc059b14-662a-431a-b310-7949435dbdc3"},
                      "defaultAudioLanguage"=>"ja"},
                      "liveStreamingDetails"=>{"actualStartTime"=>"2022-03-21T07:22:06Z", "activeLiveChatId"=>"C" }
                },
              ],
              "pageInfo"=>{"totalResults"=>1, "resultsPerPage"=>1},
            }.to_json
          )
        end
        client.video_id = "foo"
        client.my_channel_id = my_channel_id
      end

      it { expect(subject.id).to eq("eU3QvsjEH18") }
      it { expect(subject.chat_id).to eq("C") }
    end
  end

  describe '#available_live_stream' do
    let(:client) { described_class.new(streaming_service_account) }
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { client.available_live_stream }

    context '配信が見つからなかったとき' do
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

    context '有効な配信が見つかったとき' do
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
