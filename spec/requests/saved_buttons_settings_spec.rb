require 'rails_helper'

RSpec.describe "SavedButtonsSettings", type: :request do
  describe "GET /index" do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, pbm_version: "1.0") }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, device: device) }

    before do
      saved_buttons_setting
    end

    it do
      get saved_buttons_settings_path
      expect(response).to be_ok
    end
  end

  describe "DELETE /destroy" do
    let(:device) { FactoryBot.create(:device, pbm_version: "1.0") }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, device: device) }

    it do
      delete saved_buttons_setting_path(saved_buttons_setting)
      expect(response).to be_redirect
    end
  end
end
