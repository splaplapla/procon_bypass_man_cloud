require 'rails_helper'

RSpec.describe "/admin/devices", type: :request do
  include_context "login_with_admin_user"

  describe 'GET /' do
    let(:device) { FactoryBot.create(:device) }

    before do
      device
    end

    it do
      get admin_devices_path
      expect(response).to be_ok
    end
  end

  describe 'GET /:id' do
    let(:device) { FactoryBot.create(:device) }

    before do
      device
    end

    it do
      get admin_device_path(device.id)
      expect(response).to be_ok
    end
  end
end
