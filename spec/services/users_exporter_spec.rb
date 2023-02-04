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

        expect(subject[:users][user2.id][:user]).to eq(user2.dup.attributes)
        expect(subject[:users][user2.id][:devices]).to eq([])
      end
    end
  end
end
