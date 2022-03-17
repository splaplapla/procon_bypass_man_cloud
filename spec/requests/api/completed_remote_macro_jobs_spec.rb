require 'rails_helper'

describe Api::CompletedPbmRemoteMacroJobsController, type: :request do
  let(:device) { FactoryBot.create(:device) }

  describe 'POST #create' do
    subject { post api_device_completed_pbm_remote_macro_jobs_path(device.uuid), params: { job_id: remote_macro_job_uuid } }

    context '存在するjob_idでリクエストするとき' do
      let(:remote_macro_job) { RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: "a", name: "foo") }
      let(:remote_macro_job_uuid) { remote_macro_job.uuid }

      it do
        subject
        expect(response).to be_ok
      end

      it do
        expect { subject }.to change { remote_macro_job.reload.status }.to('processed')
      end
    end

    context '存在しないjob_idでリクエストするとき' do
      let(:remote_macro_job_uuid) { "foo" }

      it do
        subject
        expect(response).to be_bad_request
      end
    end
  end
end
