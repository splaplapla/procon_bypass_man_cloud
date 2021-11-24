require 'rails_helper'

RSpec.describe "/api/devices/:device_id/pbm_jobs", type: :request do
  let(:device) { Device.create(uuid: :a, hostname: "aa") }
  let(:pbm_job) { PbmJobFactory.new(device_id: device.id).build.tap{ |x| x.save! } }
  let(:failed_pbm_job) { PbmJobFactory.new(device_id: device.id).build.tap{ |x| x.save!; x.failed! } }

  describe "GET /" do
    subject { get api_device_pbm_jobs_path(device) }

    before do
      pbm_job
    end

    it do
      subject
      expect(response).to be_ok
    end

    it do
      subject
      expect(response.body).to eq([PbmJobSerializer.new(pbm_job)].to_json)
    end
  end
end
