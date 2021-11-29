require 'rails_helper'

RSpec.describe Device::CreateDeviceStatusService, type: :request do
  let(:device) { Device.create(uuid: :a, hostname: "aa") }
  let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

  subject { described_class.new(device: device, pbm_session_id: pbm_session.uuid).execute(status: status) }

  describe '#exeute' do
    context 'device_statusesを持っていないとき' do
      let(:status) { "running" }

      it do
        expect { subject }.to change { device.device_statuses.count }.by(1)
      end
    end

    context 'device_statusesを持っているとき' do
      before do
        described_class.new(device: device, pbm_session_id: pbm_session.uuid).execute(status: "running") 
      end

      context '最後のdevice_statusと同じものを引数に渡すとき' do
        let(:status) { "running" }

        context 'session_idが同じとき' do
          it do
            expect { subject }.not_to change { device.device_statuses.count }
          end
        end

        context 'session_idが違うとき' do
          let(:new_pbm_session) { PbmSession.create(uuid: :b, device: device, hostname: "a") }

          before do
            device.device_statuses.create!(status: :running, pbm_session: new_pbm_session)
          end

          it do
            expect { subject }.to change { device.device_statuses.count }.by(1)
          end
        end
      end

      context '最後のdevice_statusと異なるものを引数に渡すとき' do
        let(:status) { "device_error" }

        it do
          expect { subject }.to change { device.device_statuses.count }.by(1)
        end
      end
    end
  end
end
