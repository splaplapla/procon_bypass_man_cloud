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
          post api_events_path, params: { body: { pid: 1 }, event_type: "error", hostname: "foo" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.hostname).to be_a(String)
        expect(event.event_type).to eq('error')
      end

      it do
        post api_events_path, params: { body: { pid: 1 }, event_type: "error", hostname: "foo" }
        expect(response).to be_ok
      end
    end
  end
end
