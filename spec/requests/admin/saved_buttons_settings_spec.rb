require 'rails_helper'

RSpec.describe "SavedButtonsSettings", type: :request do
  describe 'POST /admin/events/:event_id/saved_buttons_settings' do
    let(:event) { 
      SaveEventService.execute!(session_id: "a", hostname: "b", event_type: "load_config", body: {a: 2 }, device_id: "aa")
      Event.last
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
