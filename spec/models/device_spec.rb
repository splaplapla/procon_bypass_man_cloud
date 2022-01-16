require 'rails_helper'

RSpec.describe Device, type: :model do
  describe '#generate_unique_key' do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.build(:device, user: user) }

    it do
      expect { device.save! }.to change { device.unique_key }.from(nil)
    end
  end
end
