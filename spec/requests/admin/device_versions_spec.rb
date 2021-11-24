require 'rails_helper'

RSpec.describe "/admin/device_versions", type: :request do
  describe 'GET /current' do
    let(:device) { Device.create!(uuid: "a", hostname: "hoge", pbm_version: "1.0") }

    before do
      device
    end

    it do
      get current_admin_device_device_versions_path(device)
      expect(response).to be_ok
    end
  end
end
