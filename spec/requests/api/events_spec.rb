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
          post api_events_path, params: { body: { pid: 1 }, event_type: "boot", hostname: "foo", session_id: "a", device_id: "b" }
        }.to \
          change { Event.count }.by(1).and \
          change { Device.count }.by(1)
        event = Event.last
        expect(event.pbm_session.hostname).to eq("foo")
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('boot')
      end
    end

    context 'when provide event_type is heartbeat' do
      it do
        expect {
          post api_events_path, params: { body: { pid: 1 }, event_type: "heartbeat", hostname: "foo", session_id: "a", device_id: "b" }
          post api_events_path, params: { body: { pid: 1 }, event_type: "heartbeat", hostname: "foo", session_id: "a", device_id: "b" }
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
          post api_events_path, params: { body: { pid: 1 }, event_type: "error", hostname: "foo", session_id: "a", device_id: "b" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('error')
      end

      it do
        post api_events_path, params: { body: { pid: 1 }, event_type: "error", hostname: "foo", session_id: "a", device_id: "b" }
        expect(response).to be_ok
      end
    end

    context 'when provide event_type is load_config' do
      subject { post api_events_path, params: { body: { pid: 1 }, event_type: "load_config", hostname: "foo", session_id: "a", device_id: "b" } }
      it do
        expect { subject }.to \
          change { Event.count }.by(1).and \
          change { EventButtonsSetting.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.event_type).to eq('load_config')
        buttons_setting = EventButtonsSetting.last
        expect(buttons_setting.content).to be_a(Hash)
      end

      it do
        subject
        expect(response).to be_ok
      end
    end
  end
end
