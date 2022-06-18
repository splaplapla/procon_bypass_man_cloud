require 'rails_helper'

RSpec.describe StreamingService, type: :model do
  describe 'validations' do
    describe '#prevent_to_update_service_type' do
      let(:user) { FactoryBot.create(:user) }
      let(:streaming_service) { FactoryBot.create(:streaming_service, service_type: :youtube_live, user: user) }

      subject { streaming_service.update(service_type: :twitch) }

      it 'uservice_typeを更新できないこと' do
        subject
        expect(streaming_service.valid?).to eq(false)
        expect(streaming_service.errors[:service_type].size).to eq(1)
      end
    end
  end
end
