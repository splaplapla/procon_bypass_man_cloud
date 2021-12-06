require 'rails_helper'

RSpec.describe "/admin/devices/:device_id/pbm_jobs", type: :request do
  include_context "login_with_admin_user"

  describe 'POST /change_pbm_version' do
    context 'when device.enable_pbmenvがfalseのとき' do
      let(:device) { FactoryBot.create(:device, enable_pbmenv: false) }

      subject { post admin_device_pbm_jobs_change_pbm_version_index_path(device, pbm_version: "0.1.1") }

      it do
        subject
        expect(response).to be_redirect
      end

      it do
        expect { subject }.not_to change { device.pbm_jobs.count }
      end

    end

    context 'when device.enable_pbmenvがtrueのとき' do
      let(:device) { FactoryBot.create(:device, enable_pbmenv: true) }

      subject { post admin_device_pbm_jobs_change_pbm_version_index_path(device, pbm_version: "0.1.1") }

      it do
        subject
        expect(response).to be_redirect
      end

      it do
        expect { subject }.to change { device.pbm_jobs.count }.by(1)
      end

      it do
        subject
        pbm_job = device.pbm_jobs.last
        expect(pbm_job.args).to eq("pbm_version"=>"0.1.1")
      end

      it do
        subject
        pbm_job = device.pbm_jobs.last
        expect(pbm_job.action).to eq("change_pbm_version")
      end
    end
  end
end
