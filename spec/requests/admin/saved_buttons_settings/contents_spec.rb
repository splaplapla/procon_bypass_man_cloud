require 'rails_helper'

RSpec.describe "Admin::SavedButtonsSettings::Contents", type: :request do
  include_context "login_with_admin_user"

  let(:device) { FactoryBot.create(:device, pbm_version: "1.0") }
  let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, device: device) }

  describe 'GET #edit' do
    it do
      get edit_admin_saved_buttons_settings_content_path(saved_buttons_setting)
      expect(response).to be_ok
    end
  end
end
