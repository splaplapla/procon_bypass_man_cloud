require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe '#validate_registable_devices' do
    end

    describe '#saved_buttons_settings' do
      describe 'length' do
        context 'すでに2件保存済みのとき' do
          let(:saved_buttons_settings) { 2.times.map { FactoryBot.build(:saved_buttons_setting) } }
          let(:user) { FactoryBot.create(:user, saved_buttons_settings: saved_buttons_settings) }

          it do
            user.saved_buttons_settings.build
            expect(user.valid?).to eq(false)
            expect(user.errors.added?(:saved_buttons_settings, '登録可能な個数を超えています')).to eq(true)
          end
        end

        context 'すでに1件保存済みのとき' do
          let(:saved_buttons_settings) { 1.times.map { FactoryBot.build(:saved_buttons_setting) } }
          let(:user) { FactoryBot.create(:user, saved_buttons_settings: saved_buttons_settings) }

          it do
            user.saved_buttons_settings.build
            expect(user.valid?).to eq(true)
          end
        end
      end
    end
  end
end
