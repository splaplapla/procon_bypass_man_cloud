require 'rails_helper'

RSpec.describe "/api/devices/:device_id/pbm_jobs", type: :request do
  let(:device) { FactoryBot.create(:device) }

  describe "GET /" do
    let(:pbm_job) { PbmJobFactory.new(device_id: device.id, action: :reboot_os).build.tap{ |x| x.save! } }
    subject { get api_device_pbm_jobs_path(device.uuid) }

    context 'when pbm_job' do
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

    context 'when pbm_job_has_args' do
      let(:pbm_job_has_args) { PbmJobFactory.new(device_id: device.id, action: :reboot_os, job_args: { pbm_version: "0.1.1" }).build.tap{ |x| x.save! } }

      before do
        pbm_job_has_args
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to eq([PbmJobSerializer.new(pbm_job_has_args)].to_json)
      end
    end
  end

  describe 'PUT /:id' do
    let(:pbm_job) { PbmJobFactory.new(device_id: device.id, action: :reboot_os).build.tap{ |x| x.save! } }
    subject { put api_device_pbm_job_path(device.uuid, pbm_job.uuid, body: { status: status }) }

    context 'when in_progress' do
      let(:status) { :in_progress }

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to eq(PbmJobSerializer.new(pbm_job.reload).to_json)
      end

      it do
        expect { subject }.to change { pbm_job.reload.status }.to("in_progress")
      end
    end

    context 'when processed' do
      let(:status) { :processed }

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to eq(PbmJobSerializer.new(pbm_job.reload).to_json)
      end

      it do
        expect { subject }.to change { pbm_job.reload.status }.to("processed")
      end
    end

    context 'when failed' do
      let(:status) { :failed }

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to eq(PbmJobSerializer.new(pbm_job.reload).to_json)
      end

      it do
        expect { subject }.to change { pbm_job.reload.status }.to("failed")
      end
    end
  end
end
