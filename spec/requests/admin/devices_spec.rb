require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe 'GET /admin/devices' do
    let(:device) { Device.create!(uuid: "a", hostname: "hoge") }
    before do
      device
    end

    it do
      get admin_devices_path
      expect(response).to be_ok
    end
  end

  describe 'GET /admin/devices/:id' do
    let(:device) { Device.create!(uuid: "a", hostname: "hoge") }
    before do
      device
    end

    it do
      get admin_device_path(device.id)
      expect(response).to be_ok
    end
  end
end
