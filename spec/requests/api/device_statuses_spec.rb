require 'rails_helper'

RSpec.describe "/api/devices/:device_id/device_statuses", type: :request do
  let(:device) { FactoryBot.create(:device) }
  let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

  describe 'POST /' do
    subject { post api_device_device_statuses_path(device.uuid), params: params }

    context 'statusを渡さないとき' do
      let(:params) { { boby: { pbm_session_id: pbm_session.uuid } } }

      it do
        subject
        expect(response.body).to eq({ "errors":["Status can't be blank", "Pbm session can't be blank"] }.to_json)
      end
    end

    context '定義にないstatusを渡すとき' do
      let(:params) { { body: { status: "undefined", pbm_session_id: pbm_session.uuid } } }

      it do
        subject
        expect(response.body).to eq({ "errors":["Status is invalid"] }.to_json)
      end
    end

    context '定義にあるstatusを渡すとき' do
      context 'すでにrunningが記録済みのとき' do
        let(:params) { { body: { status: "running", pbm_session_id: pbm_session.uuid } } }

        before do
          device.device_statuses.create!(status: :running, pbm_session: pbm_session)
        end

        context 'その後、current_device_status_idがnilになるとき' do
          before do
            device.update!(current_device_status_id: nil)
          end

          it do
            expect { subject }.to change { device.reload.current_device_status_id }
          end
        end
      end

      context 'when running' do
        let(:params) { { body: { status: "running", pbm_session_id: pbm_session.uuid } } }

        it do
          subject
          expect(response).to be_ok
        end

        it do
          expect { subject }.to change { device.device_statuses.count }.by(1)
        end

        it do
          expect { subject }.to change { device.reload.current_device_status_id }
        end

        context 'pbm_sessionのupdate_at' do
          let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a", updated_at: 1.minutes.ago) }

          it do
            expect { subject }.to change { pbm_session.reload.updated_at }
          end
        end
      end
    end
  end
end
