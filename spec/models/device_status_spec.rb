require 'rails_helper'

RSpec.describe DeviceStatus, type: :model do
  describe '#recent?' do
    let(:device) { Device.create(uuid: :a, hostname: "aa") }
    let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

    context '古い' do
      let(:device_status) { device.device_statuses.create!(status: :running, pbm_session: pbm_session, created_at: 1.hours.ago) }

      it do
        expect(device_status.recent?).to eq(true)
      end
    end

    context '2秒前' do
      let(:device_status) { device.device_statuses.create!(status: :running, pbm_session: pbm_session, created_at: 2.seconds.ago) }

      it do
        expect(device_status.recent?).to eq(true)
      end
    end
  end
end
