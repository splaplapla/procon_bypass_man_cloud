require 'rails_helper'

describe UsersExporter do
  describe '.execute' do
    subject { described_class.execute }

    context 'デバイスを持っていない' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:user2) { FactoryBot.create(:user, email: 'hoge@example.com') }

      it do
        expect(subject[:users][user.id][:user]).to eq(user.dup.attributes)
        expect(subject[:users][user.id][:devices]).to eq([])
        expect(subject[:users][user.id][:splatoon2_sketches]).to eq([])

        expect(subject[:users][user2.id][:user]).to eq(user2.dup.attributes)
        expect(subject[:users][user2.id][:devices]).to eq([])
        expect(subject[:users][user2.id][:splatoon2_sketches]).to eq([])
      end

      context 'splatoon2_sketchesを持っている' do
        let!(:user) { FactoryBot.create(:user) }
        let!(:splatoon2_sketch) { FactoryBot.create(:splatoon2_sketch, :has_image, user: user) }

        it 'has a hash' do
          splatoon2_sketch_hash = subject[:users][user.id][:splatoon2_sketches].first
          expect(splatoon2_sketch_hash.keys).to eq(
            ["id", "user_id", "name", "encoded_image", "binary_threshold", "crop_data", "created_at", "updated_at"]
          )
          expect(splatoon2_sketch_hash['id']).to be_nil
        end
      end
    end

    context 'デバイスを持っている' do
      let!(:user) { FactoryBot.create(:user, devices: [device]) }
      let(:device) { FactoryBot.create(:device) }

      context '他は何もない' do
        it do
          result = subject
          expect(result[:users][user.id][:user][:email]).to eq(user.email)
          expect(result[:users][user.id][:saved_buttons_settings]).to eq([])
        end

        it do
          result = subject
          expect(result[:users][user.id][:devices].size).to eq(1)
          device = result[:users][user.id][:devices].first
          expect(device[:events]).to eq([])
          expect(device[:pbm_sessions]).to eq([])
        end
      end

      context 'saved_buttons_settingsを持っている' do
        let!(:user) { FactoryBot.create(:user, devices: [device]) }
        let(:device) { FactoryBot.create(:device) }
        let!(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }

        it do
          result = subject
          devices = result[:users][user.id][:devices]
          expect(devices.size).to eq(1)
        end

        it do
          result = subject
          saved_buttons_settings = result[:users][user.id][:saved_buttons_settings]
          expect(saved_buttons_settings.size).to eq(1)
          local_saved_buttons_setting = saved_buttons_settings.first
          expect(local_saved_buttons_setting).to include('content_hash' => saved_buttons_setting.content_hash)
        end
      end

      context 'pbm_sessions, eventsを持っている' do
        let!(:pbm_session) { PbmSession.create!(uuid: :b, device: device, hostname: "a") }
        let!(:event) { pbm_session.events.create!(event_type: :boot) }

        it do
          result = subject
          devices = result[:users][user.id][:devices]
          expect(devices.size).to eq(1)
        end

        it do
          result = subject
          devices = result[:users][user.id][:devices]
          device_hash = devices.first
          expect(device_hash.keys).to eq([:device, :events, :pbm_sessions])
        end

        it do
          result = subject
          devices = result[:users][user.id][:devices]
          device_hash = devices.first
          expect(device_hash[:events].size).to eq(1)
          expect(device_hash[:events].first).to include('event_type' => 'boot')
        end

        it do
          result = subject
          devices = result[:users][user.id][:devices]
          device_hash = devices.first
          expect(device_hash[:pbm_sessions].size).to eq(1)
          expect(device_hash[:pbm_sessions].first).to include('uuid' => 'b')
        end
      end
    end
  end
end
