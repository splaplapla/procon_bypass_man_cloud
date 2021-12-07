require 'rails_helper'

RSpec.describe "/admin/devices/:device_id/pbm_jobs", type: :request do
  include_context "login_with_admin_user"

  describe 'POST /restore_pbm_setting' do
    let(:device) { FactoryBot.create(:device) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, device: device) }

    subject { post admin_device_pbm_jobs_restore_pbm_setting_index_path(device, saved_buttons_setting_id: saved_buttons_setting.id) }

    before do
      device
    end

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { PbmJob.count }.by(1)
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
  end
end
