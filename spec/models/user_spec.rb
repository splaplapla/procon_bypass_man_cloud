require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe '.saved_buttons_settings' do
      describe 'length' do
        context 'すでに10件保存済みのとき' do
          let(:saved_buttons_settings) { 10.times.map { FactoryBot.build(:saved_buttons_setting) } }
          let(:user) { FactoryBot.create(:user, saved_buttons_settings: saved_buttons_settings) }

          it do
            user.saved_buttons_settings.build
            expect(user.valid?).to eq(false)
            expect(user.errors.added?(:saved_buttons_settings, :too_long, count: 10)).to eq(true)
          end
        end
      end
    end
  end
end
