require 'rails_helper'

RSpec.describe "Admin::SavedButtonsSettings::Contents", type: :request do
  include_context "login_with_admin_user"

  describe 'GET #edit' do
    context 'has valid setting' do
      let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: admin_user) }

      it do
        get edit_admin_saved_buttons_settings_content_path(saved_buttons_setting)
        expect(response).to be_ok
      end
    end

    context 'has invalid setting' do
      let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: admin_user, content: { a: 1 }) }

      it do
        get edit_admin_saved_buttons_settings_content_path(saved_buttons_setting)
        expect(response).to be_ok
      end
    end
  end
end
