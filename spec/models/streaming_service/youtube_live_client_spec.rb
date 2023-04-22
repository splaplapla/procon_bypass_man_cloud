require 'rails_helper'

describe StreamingService::YoutubeLiveClient do
  let(:client) { described_class.new(streaming_service_account) }

  describe '#chat_messages' do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { client.chat_messages }

    before do
      allow(StreamingService::YoutubeLiveClient::ChatMessagesRequest).to receive(:request) do
        OpenStruct.new(
          code: '200',
          body: {
            "kind"=>"youtube#liveChatMessageListResponse",
            "etag"=>"nwZZWVIIhKjZ4Dmyypt_zJh2s7U",
            "pollingIntervalMillis"=>4889,
            "pageInfo"=>{"totalResults"=>21, "resultsPerPage"=>18},
            "nextPageToken"=>"GL2e8Oes2_YCIIjIwv6s2_YC",
            "items"=> [
              { "kind"=>"youtube#liveChatMessage",
                "etag"=>"BNXbTPpH53AlfXn29tL-79mckTQ",
                "id"=>"LCC.CjgKDQoLMGZwYm9GQWJNRDAqJwoYVUN1VEFYVGV4cmhldGJPZTN6Z3NrSkJREgswZnBib0ZBYk1EMBJFChpDT2Z1cU5TWDJfWUNGYlFLZlFvZDBMVU96URInQ01ibDNyLVgyX1lDRll3eFdBb2RkLVVJeHcxNjQ4MDAyNDgxMTc2",
                "snippet"=> { "type"=>"textMessageEvent",
                              "liveChatId"=>"Cg0KCzBmcGJvRkFiTUQwKicKGFVDdVRBWFRleHJoZXRiT2Uzemdza0pCURILMGZwYm9GQWJNRDA",
                              "authorChannelId"=>"UC18DensR1cKwdzHy4Q8c5qw",
                              "publishedAt"=>"2022-03-23T02:28:02.190226+00:00",
                              "hasDisplayContent"=>true,
                              "displayMessage"=>"ドクターイエロー汐留のライブカメラ通過",
                              "textMessageDetails"=>{"messageText"=>"ドクターイエロー汐留のライブカメラ通過"} },
            "authorDetails"=> {
              "channelId"=>"UC18DensR1cKwdzHy4Q8c5qw",
              "channelUrl"=>"http://www.youtube.com/channel/UC18DensR1cKwdzHy4Q8c5qw",
              "displayName"=>"天空の白鷺",
              "profileImageUrl"=>"https://yt3.ggpht.com/b77SUkgWkz4qK1PnTXM5ELRT8jBZXcxt1Dc2CUrooOYHJDQpfm0RCGvdZlZHYnO2L6hCxvhS0Q=s88-c-k-c0x00ffffff-no-rj",
              "isVerified"=>false,
              "isChatOwner"=>false,
              "isChatSponsor"=>false,
              "isChatModerator"=>false }
              }
            ]
          }.to_json
        )
      end
      client.chat_id = "foo"
      client.video_id = "foo"
    end

    it { expect(subject.first).to eq("GL2e8Oes2_YCIIjIwv6s2_YC") }

    describe 'message' do
      let(:message)  { subject.last.last }

      it { expect(message.body).to eq("ドクターイエロー汐留のライブカメラ通過") }
      it { expect(message.author_channel_id).to eq("UC18DensR1cKwdzHy4Q8c5qw") }
      it { expect(message.author_name).to eq("天空の白鷺") }
      it { expect(message.owner).to eq(false) }
      it { expect(message.moderator).to eq(false) }
      it { expect(message.published_at).to eq("2022-03-23T02:28:02.190226+00:00".to_time) }
    end
  end

  describe '#active_streaming_video' do
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
                    "description"=>"https://github.com/splaplapla/procon_bypass_man を使っています\n\n使用中の設定は👇です\nhttps://pbm-cloud.jiikko.com/p/bc059b14-662a-431a-b310-7949435dbdc3",
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
                      "title"=>"テスト", "description"=>"https://github.com/splaplapla/procon_bypass_man を使っています\n\n使用中の設定は👇です\nhttps://pbm-cloud.jiikko.com/p/bc059b14-662a-431a-b310-7949435dbdc3"},
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
