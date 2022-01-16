require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe "GET /index" do
    context 'ログインしている' do
      include_context "login_with_admin_user"

      it do
        get devices_path
        expect(response).to be_ok
      end
    end

    context 'ログインしていない' do
      it  do
        get devices_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /show" do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user) }

    it  do
      get device_path(device.unique_key)
      expect(response).to be_ok
    end
  end
end
