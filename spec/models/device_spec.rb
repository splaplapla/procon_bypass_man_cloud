require 'rails_helper'

RSpec.describe Device, type: :model do
  describe '#generate_unique_key' do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.build(:device, user: user) }

    it do
      expect { device.save! }.to change { device.unique_key }.from(nil)
    end
  end

  describe '#current_device_status_name' do
    let(:device) { FactoryBot.create(:device) }

    subject { device.current_device_status_name }

    context 'current_device_status_idの実態が存在しない時' do
      before do
        device.update!(current_device_status_id: 0)
      end

      it { expect(subject).to eq('offline') }
    end
  end
end
