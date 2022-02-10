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

  describe "GET /new" do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user) }

    it  do
      get new_device_path
      expect(response).to be_ok
    end
  end

  describe "GET /create" do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: nil) }

    subject { post devices_path, params: { device: { uuid: device_uuid } } }

    context 'デバイスが見つかったとき' do
      let(:device_uuid) { device.uuid }
      it  do
        subject
        expect(response).to be_redirect
      end
      it { expect { subject }.to change { user.devices.count }.by(1) }
    end
    context 'デバイスが見つからなかったとき' do
      let(:device_uuid) { "foo" }
      it  do
        subject
        expect(response).to be_ok
      end
      it { expect { subject }.not_to change { user.devices.count } }
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

  describe 'POST /restore_setting' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar") }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user, content: { a: 1 }) }

    subject { post restore_setting_device_path(device.unique_key, saved_buttons_setting_id: saved_buttons_setting.id, format: :js) }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.args).to eq({ "setting" => {"a"=>1}, "setting_name" => "title2" })
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.action).to eq("restore_pbm_setting")
    end

    it do
      expect { subject }.to have_broadcasted_to(device.push_token)
    end
  end

  describe 'POST /offline' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar", current_device_status_id: 0) }
    let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

    subject { post offline_device_path(device.unique_key) }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      expect { subject }.to change { device.reload.current_device_status_id }.to(nil)
    end
  end
end
