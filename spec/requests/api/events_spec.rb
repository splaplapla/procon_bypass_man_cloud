require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "POST /events" do
    let(:device) { Device.create(uuid: :a, hostname: "aa") }
    let(:device_id) { device.uuid }

    subject do
      post api_events_path, params: { body: params_body.to_json, event_type: event_type, hostname: "foo", session_id: "a", device_id: device_id }
    end

    context 'does not provide params' do
      it do
        expect { post api_events_path }.not_to change { Event.count }
        expect(response).to be_bad_request
      end
    end

    context 'when provide event_type is boot' do
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }
      let(:event_type) { :boot }

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
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }
      let(:event_type) { :heartbeat }

      it do
        expect { subject }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('heartbeat')
      end
    end

    context 'when provide event_type is error' do
      let(:event_type) { :error }
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }

      it do
        expect { subject }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.pbm_session.hostname).to be_a(String)
        expect(event.event_type).to eq('error')
      end

      it do
        subject
        expect(response).to be_ok
      end
    end

    context 'when provide event_type is load_config' do
      let(:event_type) { :load_config }
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }

      it do
        expect { subject }.to change { Event.count }.by(1)
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
