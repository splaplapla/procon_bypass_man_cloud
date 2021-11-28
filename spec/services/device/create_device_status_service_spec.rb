require 'rails_helper'

RSpec.describe Device::CreateDeviceStatusService, type: :request do
  let(:device) { Device.create(uuid: :a, hostname: "aa") }

  subject { described_class.new(device: device).execute(status: status) }

  describe '#exeute' do
    context 'device_statusesを持っていないとき' do
      let(:status) { "running" }

      it do
        expect { subject }.to change { device.device_statuses.count }.by(1)
      end
    end

    context 'device_statusesを持っているとき' do
      before do
        described_class.new(device: device).execute(status: "running")
      end

      context '最後のdevice_statusと同じものを引数に渡すとき' do
        let(:status) { "running" }

        it do
          expect { subject }.not_to change { device.device_statuses.count }
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
