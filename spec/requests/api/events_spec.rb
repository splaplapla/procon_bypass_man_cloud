require 'rails_helper'

RSpec.describe Api::EventsController, type: :request do
  describe "POST /events" do
    let(:device) { FactoryBot.create(:device) }
    let(:device_id) { device.uuid }

    subject do
      post api_events_path, params: { body: params_body, event_type: event_type, hostname: "foo", session_id: "a", device_id: device_id }
    end

    context 'does not provide params' do
      it do
        expect { post api_events_path }.not_to change { Event.count }
        expect(response).to be_bad_request
      end
    end

    context 'when provide event_type is boot' do
      let(:event_type) { :boot }

      context 'when using pbmenv' do
        let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true, root_path: "/usr/share/pbm/v0.11" } }

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

      context 'when do not using pbmenv' do
        let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true, root_path: "/home/pi/sample" } }

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
          expect { subject }.not_to change { device.reload.enable_pbmenv }
          expect(device.reload.enable_pbmenv).to eq(false)
        end
      end
    end

    context 'when provide event_type is start_reboot' do
      let(:event_type) { :start_reboot }
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }

      it do
        expect { subject }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.event_type).to eq('start_reboot')
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        expect { subject }.to have_broadcasted_to(device.web_push_token)
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

      context do
        it do
          params = {"session_id"=>"s_ff09e6f0-050b-4dcb-b079-ac32c88f57a3", "device_id"=>"d_9fadc91f-6575-4f4a-b58d-fe66e557758b", "hostname"=>"raspberrypi2", "event_type"=>"heartbeat", "body"=>{"ruby_version"=>"3.0.1", "pbm_version"=>"0.1.14", "pid"=>983, "root_path"=>"/usr/share/pbm/v0.1.11", "pid_path"=>"/usr/share/pbm/v0.1.11/pbm_pid", "setting_path"=>"/usr/share/pbm/current/setting.yml", "uptime_from_boot"=>66, "use_pbmenv"=>true}, "event"=>{"body"=>{"ruby_version"=>"3.0.1", "pbm_version"=>"0.1.14", "pid"=>983, "root_path"=>"/usr/share/pbm/v0.1.11", "pid_path"=>"/usr/share/pbm/v0.1.11/pbm_pid", "setting_path"=>"/usr/share/pbm/current/setting.yml", "uptime_from_boot"=>66, "use_pbmenv"=>true}, "event_type"=>"heartbeat"} }
          post api_events_path, params: params
        end
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

    context 'when provide event_type is reload_config' do
      let(:event_type) { :reload_config }
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }

      it do
        expect { subject }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.event_type).to eq('reload_config')
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        expect { subject }.to have_broadcasted_to(device.web_push_token)
      end
    end

    context 'when provide event_type is reload_config' do
      let(:event_type) { :error_reload_config }
      let(:params_body) { { pid: 1, pbm_version: "1.1", use_pbmenv: true } }

      it do
        expect { subject }.to change { Event.count }.by(1)
        event = Event.last
        expect(event.body).to be_a(Hash)
        expect(event.event_type).to eq('error')
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        expect { subject }.to have_broadcasted_to(device.web_push_token)
      end
    end
  end
end
