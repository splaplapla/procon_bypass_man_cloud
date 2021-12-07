require 'rails_helper'

RSpec.describe "SavedButtonsSettings", type: :request do
  include_context "login_with_admin_user"

  describe 'GET index' do
    let(:device) { FactoryBot.create(:device) }

    it do
      get admin_device_saved_buttons_settings_path(device)
      expect(response).to be_ok
    end
  end

  describe 'PUT update' do
    let(:device) { FactoryBot.create(:device) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, device: device) }

    subject { put admin_saved_buttons_setting_path(saved_buttons_setting), params: { name: "hoge" } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { saved_buttons_setting.reload.name }
    end
  end

  describe 'POST create' do
    let(:event) { 
      SaveEventService.execute!(session_id: "a", hostname: "b", event_type: "load_config", body: {a: 2 }, device_id: "aa")
    }

    it do
      post admin_event_saved_buttons_settings_path(event)
      expect(response).to be_redirect
    end

    it do
      expect {
        post admin_event_saved_buttons_settings_path(event)
      }.to change { SavedButtonsSetting.count }.by(1)
    end
  end
end
