require 'rails_helper'

RSpec.describe SavedButtonsSetting, type: :model do
  describe '#update_content_hash' do
    let(:user) { FactoryBot.create(:user) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }
    it do
      expect { saved_buttons_setting.update!(content: { setting: "foo" }) }.to(change { saved_buttons_setting.content_hash })
    end
  end
end
