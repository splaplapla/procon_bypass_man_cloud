require 'rails_helper'

describe UsersExporter do
  describe '.execute' do
    subject { described_class.execute }

    context 'when user_has_no_devices' do
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
end
