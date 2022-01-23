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

  describe 'PUT /update_name' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar") }

    subject { put update_name_device_path(device.unique_key), params: { device_name: "foo" } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { device.reload.name }.from("bar").to("foo")
    end
  end

  describe 'POST /ping' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar") }

    subject { post ping_device_path(device.unique_key) }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'POST /restart' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar") }

    subject { post restart_device_path(device.unique_key) }

    it do
      subject
      expect(response).to be_redirect
    end
  end

  describe 'GET /current_status' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar") }
    # ActionController::InvalidCrossOriginRequestになるのでroutesのテストだけでいいのでheadにする
    subject { head current_status_device_path(device.unique_key, format: :js) }

    it do
      subject
      expect(response).to be_ok
    end
  end
end
