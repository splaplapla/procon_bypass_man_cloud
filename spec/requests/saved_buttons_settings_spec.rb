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

  describe 'POST /create' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user) }
    let(:event) do
      Api::SaveEventService.execute!(
        session_id: "session_id",
        hostname: "hostname",
        event_type: "load_config",
        body: "hjk",
        device_id: device.uuid,
      )
    end

    subject { post saved_buttons_settings_path, params: { event_id: event.id, name: "a", memo: "b" } }

    it do
      expect { subject }.to change { user.saved_buttons_settings.count }.by(1)
    end

    it do
      subject
      expect(response).to be_redirect
    end
  end

  describe 'PUT /update' do
    include_context "login_with_user"

    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user, name: "foo") }

    subject { put saved_buttons_setting_path(saved_buttons_setting), params: { saved_buttons_setting: { name: :updated } } }

    it { expect { subject }.to change { saved_buttons_setting.reload.name } }
    it do
      subject
      expect(response).to be_redirect
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
