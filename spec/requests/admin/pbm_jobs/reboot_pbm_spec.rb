require 'rails_helper'

RSpec.describe "/admin/devices/:device_id/pbm_jobs", type: :request do
  describe 'POST /reboot_pbm' do
    let(:device) { Device.create!(uuid: "a", hostname: "hoge", pbm_version: "1.0") }

    subject { post admin_device_pbm_jobs_reboot_pbm_index_path(device) }

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
      expect(pbm_job.args).to eq({})
    end

    it do
      subject
      pbm_job = device.pbm_jobs.last
      expect(pbm_job.action).to eq("reboot_pbm")
    end
  end
end
