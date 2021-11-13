require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "POST/events" do

    context 'does not provide params' do
      it do
        expect { post api_events_path }.not_to change { Event.count }
        expect(response).to be_bad_request
      end

      it do
        expect {
          post api_events_path, params: { body: "a", event_type: "error", hostname: "foo" }
        }.to change { Event.count }.by(1)
        expect(response).to have_http_status(200)
      end

      it do
        post api_events_path, params: { body: "a", event_type: "error", hostname: "foo" }
        expect(response).to have_http_status(200)
      end
    end
  end
  end
