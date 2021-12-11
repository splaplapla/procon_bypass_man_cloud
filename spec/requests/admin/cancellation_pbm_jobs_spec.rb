require 'rails_helper'

RSpec.describe "CancellationPbmJobs", type: :request do
  include_context "login_with_admin_user"

  describe 'GET /create' do
    let(:device) { FactoryBot.create(:device, pbm_version: "1.0") }
    let(:pbm_job) { FactoryBot.create(:pbm_job, :action_reboot_os, device: device) }

    subject { post admin_pbm_job_cancellation_pbm_jobs_path(pbm_job) }

    it do
      pbm_job
      expect { subject }.to change { pbm_job.reload.status }.to("canceled")
    end
  end
end
