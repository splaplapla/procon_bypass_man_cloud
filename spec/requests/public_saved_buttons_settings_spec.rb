require 'rails_helper'

RSpec.describe PublicSavedButtonsSettingsController, type: :request do
  describe "GET #show" do
    let(:user) { FactoryBot.create(:user) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }
    let(:public_saved_buttons_setting) { saved_buttons_setting.create_public_saved_buttons_setting }
    it do
      get public_saved_buttons_setting_path(public_saved_buttons_setting.unique_key)
      expect(response).to be_ok
    end
  end
end
