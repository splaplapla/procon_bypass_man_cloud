require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "POST /events" do
    context 'does not provide params' do
      it do
        expect { post api_events_path }.not_to change { Event.count }
        expect(response).to be_bad_request
      end
    end

    context 'when provide event_type is boot' do
      it do
        expect {
          post api_events_path, params: { body: { pid: 1 }, event_type: "boot", hostname: "foo", session_id: "a" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('boot')
      end
    end

    context 'when provide event_type is heartbeat' do
      it do
        expect {
          post api_events_path, params: { body: { pid: 1 }, event_type: "heartbeat", hostname: "foo", session_id: "a" }
          post api_events_path, params: { body: { pid: 1 }, event_type: "heartbeat", hostname: "foo", session_id: "a" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('heartbeat')
      end
    end

    context 'when provide event_type is error' do
      it do
        expect {
          post api_events_path, params: { body: { pid: 1 }, event_type: "error", hostname: "foo", session_id: "a" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('error')
      end

      it do
        post api_events_path, params: { body: { pid: 1 }, event_type: "error", hostname: "foo", session_id: "a" }
        expect(response).to be_ok
      end
    end
  end
end
