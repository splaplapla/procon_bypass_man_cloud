require 'rails_helper'

RSpec.describe "Admin::PbmJobs::RebootOs", type: :request do
  include_context "login_with_admin_user"

  describe 'POST create' do
    let(:device) { FactoryBot.create(:device) }

    subject { post admin_device_pbm_jobs_reboot_os_path(device) }

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
      expect(pbm_job.args).to eq({})
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.action).to eq("reboot_os")
    end
  end
end
