require 'rails_helper'

RSpec.describe CanChangeUserPlan, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '#be_free!' do
    subject { user.be_free! }

    it do
      subject
      expect(user.plan_name).to eq(:free)
    end
  end

  describe '#be_light!' do
    subject { user.be_light! }

    it do
      subject
      expect(user.plan_name).to eq(:light)
    end
  end

  describe '#be_standard!' do
    subject { user.be_standard! }

    it do
      subject
      expect(user.plan_name).to eq(:standard)
    end
  end

  describe '#be_pro!' do
    subject { user.be_pro! }

    it do
      subject
      expect(user.plan_name).to eq(:pro)
    end
  end
end
