require 'rails_helper'

RSpec.describe "/admin/devices/:device_id/pbm_jobs", type: :request do
  describe 'POST /reboot_pbm' do
    let(:device) { Device.create!(uuid: "a", hostname: "hoge", pbm_version: "1.0") }

    subject { post admin_device_pbm_jobs_change_pbm_version_index_path(device, next_version: "0.1.1") }

    before do
      device
    end

    it do
      subject
      expect(response).to be_ok
    end

    it do
      expect { subject }.to change { PbmJob.count }.by(1)
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.args).to eq("next_version"=>"0.1.1")
    end
  end
end
