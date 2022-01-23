require 'rails_helper'

RSpec.describe "Admin::PbmJobs::RestorePbmSetting", type: :request do
  include_context "login_with_admin_user"

  describe 'POST create' do
    let(:device) { FactoryBot.create(:device) }
    let(:saved_buttons_setting) { FactoryBot.create(:saved_buttons_setting, user: admin_user, content: { a: 1 }) }

    subject { post admin_device_pbm_jobs_restore_pbm_setting_index_path(device, saved_buttons_setting_id: saved_buttons_setting.id) }

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
      expect(pbm_job.args).to eq({ "content" => {"a"=>1}, "setting_name" => "title2" })
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.action).to eq("restore_pbm_setting")
    end
  end
end
