require 'rails_helper'

describe StreamingService::TwitchClient do
  let(:client) { described_class.new(streaming_service_account) }

  describe '#myself_live' do
    subject { client.myself_live }

    it do
    end
  end

  describe '#myself' do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, device: device, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { client.myself }

    it do
      allow(StreamingService::TwitchClient::BaseRequest).to receive(:do_request) do
        OpenStruct.new(
          code: '200',
          body: {
            "data"=> [
              { "id"=>"138298415",
                "login"=>"jiikko28",
                "display_name"=>"かわぐ",
                "type"=>"",
                "broadcaster_type"=>"",
                "description"=>"Ruby on Railsをおしえるのでスプラトゥーンをおしえてください",
                "profile_image_url"=>"https://static-cdn.jtvnw.net/jtv_user_pictures/6f103584-5316-4825-beea-cc778d55e658-profile_image-300x300.png",
                "offline_image_url"=>"",
                "view_count"=>173,
                "email"=>"n905i.1214@gmail.com",
                "created_at"=>"2016-10-30T09:03:27Z" },
              ],
          }.to_json,
        )
      end
      expect(subject.id).to eq("138298415")
      expect(subject.login).to eq("jiikko28")
      expect(subject.display_name).to eq("かわぐ")
    end
  end
end
