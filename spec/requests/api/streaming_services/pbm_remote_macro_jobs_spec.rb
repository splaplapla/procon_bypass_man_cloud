require 'rails_helper'

describe Api::StreamingServices::PbmRemoteMacroJobsController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:device) { FactoryBot.create(:device, user: user) }
  let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "", trigger_word_list: ["bar"]) }
  let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
  let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }

  before do
    remote_macro
  end

  describe 'POST #enqueue' do
    subject { post api_device_streaming_service_enqueue_pbm_remote_macro_jobs_path(device.uuid, streaming_service_unique_key, word) }

    context 'streaming_service_idが存在しないとき' do
      let(:streaming_service_unique_key) { "aaa" }
      let(:word) { "bar" }

      it do
        subject
        expect(response).to be_bad_request
      end
    end

    context 'streaming_service_idが存在するとき' do
      let(:streaming_service_unique_key) { streaming_service.unique_key }

      context 'wordがヒットしないとき' do
        let(:word) { "fooo" }

        it do
          subject
          expect(response).to be_bad_request
        end

        it do
          expect { subject }.not_to have_broadcasted_to(device.push_token)
        end

        it do
          expect { subject }.not_to(change { device.pbm_remote_macro_jobs.count })
        end
      end

      context 'wordがヒットするとき' do
        let(:word) { "bar" }

        it do
          subject
          expect(response).to be_ok
        end

        it do
          expect { subject }.to have_broadcasted_to(device.push_token)
        end

        it do
          expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1)
        end
      end
    end
  end
end
