require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "POST /events" do
    let(:device) { Device.create(uuid: :a, hostname: "aa") }
    let(:device_id) { device.uuid }
    subject do
      post api_events_path, params: { body: params_body.to_json, event_type: "boot", hostname: "foo", session_id: "a", device_id: device_id }
    end
    context 'does not provide params' do
      it do
        expect { post api_events_path }.not_to change { Event.count }
        expect(response).to be_bad_request
      end
    end

    context 'when provide event_type is boot' do
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }
      it do
        expect { subject }.to \
          change { Event.count }.by(1).and \
          change { Device.count }.by(1)
        event = Event.last
        expect(event.pbm_session.hostname).to eq("foo")
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('boot')
      end

      it do
        expect { subject }.to change { device.reload.pbm_version }.to("1.1")
      end

      it do
        expect { subject }.to change { device.reload.enable_pbmenv }.to(true)
      end
    end

    context 'when provide event_type is heartbeat' do
      it do
        expect {
          post api_events_path, params: { body: { pid: 1 }.to_json, event_type: "heartbeat", hostname: "foo", session_id: "a", device_id: "b" }
          post api_events_path, params: { body: { pid: 1 }.to_json, event_type: "heartbeat", hostname: "foo", session_id: "a", device_id: "b" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('heartbeat')
      end
    end

    context 'when provide event_type is error' do
      context do
        it do
          post api_events_path, params: { "body"=>{"value"=>"\"接続の見込みがないのでsleepしまくります\"", "event_type"=>"error"}, "hostname"=>"raspberrypi", "event_type"=>"error", "session_id"=>"s_029caaea-8812-4d50-bb59-c92ca7514f6f", "device_id"=>"d_8b0c90d8-901e-45e0-a9ef-c4a874972948" }
        expect(response).to be_bad_request
        end
      end
      it do
        expect {
          post api_events_path, params: { body: { pid: 1 }.to_json, event_type: "error", hostname: "foo", session_id: "a", device_id: "b" }
        }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('error')
      end

      it do
        post api_events_path, params: { body: { pid: 1 }.to_json, event_type: "error", hostname: "foo", session_id: "a", device_id: "b" }
        expect(response).to be_ok
      end
    end

    context 'when provide event_type is load_config' do
      subject { post api_events_path, params: { body: { pid: 1 }.to_json, event_type: "load_config", hostname: "foo", session_id: "a", device_id: "b" } }
      it do
        expect { subject }.to \
          change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.event_type).to eq('load_config')
      end

      it do
        subject
        expect(response).to be_ok
      end
    end
  end
end
