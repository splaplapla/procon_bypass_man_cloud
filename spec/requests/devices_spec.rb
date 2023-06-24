require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe "GET /index" do

    subject { get devices_path }

    context 'ログインしている' do
      include_context "login_with_admin_user"

      it do
        subject
        expect(response).to be_ok
      end
    end

    context 'ログインしていない' do
      it  do
        subject
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /show" do
    include_context "login_with_user"

    subject { get device_path(device.unique_key) }

    describe do
      let(:device) { FactoryBot.create(:device, user: user) }

      it do
        subject
        expect(response).to be_ok
      end
    end

    describe '利用可能なバージョン' do
      before do
        ProconBypassManVersion.create!(name: "0.1.2")
        ProconBypassManVersion.create!(name: "0.1.3")
      end

      context '利用可能なバージョンがあるとき' do
        let(:device) { FactoryBot.create(:device, user: user, pbm_version: "0.1.2") }

        it do
          subject
          expect(response).to be_ok
        end
      end

      context '利用可能なバージョンがないとき' do
        let(:device) { FactoryBot.create(:device, user: user, pbm_version: "0.1.3") }

        it do
          subject
          expect(response).to be_ok
        end
      end
    end

    context '有効なcurrent_pbm_sessionを持っているとき' do
      let(:device) { FactoryBot.create(:device, user: user) }
      let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }
      let(:device_status) { device.device_statuses.create!(status: :running, pbm_session: pbm_session) }

      before do
        device.update!(current_device_status: device_status)
      end

      it do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe "GET /new" do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user) }

    subject { get new_device_path }

    it  do
      subject
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

      context 'すでに2台を登録している' do
        before do
          FactoryBot.create(:device, user: user)
          FactoryBot.create(:device, user: user)
        end

        it { expect { subject }.to raise_error(RuntimeError) }
      end
    end

    context 'デバイスが見つからなかったとき' do
      let(:device_uuid) { "foo" }
      it  do
        subject
        expect(response).to be_ok
      end
      it { expect { subject }.not_to(change { user.devices.count }) }
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

    subject { post restart_device_path(device.unique_key, format: :js) }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      expect { subject }.to have_broadcasted_to(device.push_token)
    end
  end

  describe 'POST /pbm_upgrade' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar", current_device_status_id: 0, enable_pbmenv: true) }
    let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

    subject { post pbm_upgrade_device_path(device.unique_key, format: :js), params: { pbm_version: "0.1.1" } }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      expect { subject }.to change { device.pbm_jobs.count }.by(1)
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.action).to eq("change_pbm_version")
    end

    it do
      expect { subject }.to have_broadcasted_to(device.push_token)
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
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user) }

    subject { post restore_setting_device_path(device.unique_key, saved_buttons_setting_id: saved_buttons_setting.id, format: :js) }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      expect { subject }.to change { device.pbm_jobs.count }.by(1)
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.args['setting_name']).to eq("title2")
      expect(pbm_job.args['setting']).to eq(saved_buttons_setting.content)
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

  describe 'POST /restore_editable_setting' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar") }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: user, content: { a: 1 }) }

    subject { post restore_editable_setting_device_path(device.unique_key, setting_content: { a: 1 }, format: :js) }

    it do
      subject
      expect(response).to be_ok
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.args).to eq({ "setting" => { 'setting' => {"a"=>'1' } }, "setting_name" => "manual input setting" })
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

  describe 'DELETE /detach' do
    include_context "login_with_user"

    let(:device) { FactoryBot.create(:device, user: user, name: "bar", current_device_status_id: 0) }
    let(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

    subject { delete detach_device_path(device.unique_key) }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { device.reload.user_id }.to(nil)
    end
  end
end
