require 'rails_helper'

RSpec.describe "SavedButtonsSettings", type: :request do
  describe "GET /index" do
    include_context "login_with_user"

    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }

    before do
      saved_buttons_setting
    end

    it do
      get saved_buttons_settings_path
      expect(response).to be_ok
    end
  end

  describe "DELETE /destroy" do
    include_context "login_with_user"

    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }

    before do
      saved_buttons_setting
    end

    it do
      delete saved_buttons_setting_path(saved_buttons_setting)
      expect(response).to be_redirect
    end

    it do
      expect { delete saved_buttons_setting_path(saved_buttons_setting) }.to change { user.saved_buttons_settings.count }.by(-1)
    end
  end
end
