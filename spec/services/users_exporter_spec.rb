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

      xcontext 'eventsを持っている' do
      end

      xcontext 'pbm_sessionsを持っている' do
      end
    end
  end
end
