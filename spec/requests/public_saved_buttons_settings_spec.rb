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

  describe "post #create" do
    include_context "login_with_user"

    subject { post saved_buttons_setting_public_saved_buttons_settings_path(saved_buttons_setting.id) }
    let(:user) { FactoryBot.create(:user) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { PublicSavedButtonsSetting.count }.by(1)
    end
  end

  describe "post #destroy" do
    include_context "login_with_user"

    subject { delete saved_buttons_setting_public_saved_buttons_setting_path(saved_buttons_setting.id, public_saved_buttons_setting.id) }
    let(:user) { FactoryBot.create(:user) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }
    let(:public_saved_buttons_setting) { saved_buttons_setting.create_public_saved_buttons_setting }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      public_saved_buttons_setting
      expect { subject }.to change { PublicSavedButtonsSetting.count }.by(-1)
    end
  end
end
