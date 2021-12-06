require 'rails_helper'

RSpec.describe "/admin/devices/:device_id/pbm_jobs", type: :request do
  include_context "login_with_admin_user"

  describe 'POST /stop_pbm' do
    let(:device) { FactoryBot.create(:device) }

    subject { post admin_device_pbm_jobs_stop_pbm_index_path(device) }

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
      expect(pbm_job.action).to eq("stop_pbm")
    end

    context '既に実行待ちのジョブがあるとき' do
      it do
        expect {
          post admin_device_pbm_jobs_stop_pbm_index_path(device)
          post admin_device_pbm_jobs_stop_pbm_index_path(device)
        }.to change { PbmJob.count }.by(1)
      end
    end
  end
end
