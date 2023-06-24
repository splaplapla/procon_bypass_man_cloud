require 'rails_helper'

RSpec.describe StreamingServices::TwitchController, type: :request do
  describe 'GET #new' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { get new_streaming_service_twitch_path(streaming_service) }

    before do
      streaming_service_account
    end

    context '配信中のライブがあるとき' do
      let(:live_video) { double(:live).as_null_object }
      let(:client) { double(:client) }

      before do
        allow(live_video).to receive(:thumbnail_url) { "/" }
        allow(live_video).to receive(:started_at) { Time.zone.now }
        allow(client).to receive(:myself_live) { live_video }
        allow(StreamingService::TwitchClient).to receive(:new) { client }
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to include("配信中のライブが見つかりました。")
      end
    end

    context '配信中のライブがないとき' do
      before do
        client = double(:client)
        allow(client).to receive(:myself_live)
        allow(StreamingService::TwitchClient).to receive(:new) { client }
      end

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(response.body).to include("配信中のライブが見つかりません")
      end
    end
  end

  describe 'GET #show' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user, remote_macro_group: remote_macro_group) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }
    let(:live_video) { double(:live).as_null_object }
    let(:client) { double(:client) }

    subject { get streaming_service_twitch_path(streaming_service, "foo") }

    before do
      streaming_service_account

      allow(live_video).to receive(:thumbnail_url) { "/" }
      allow(live_video).to receive(:started_at) { Time.zone.now }
      allow(client).to receive(:myself) { double(:user).as_null_object }
      allow(client).to receive(:myself_live) { live_video }
      allow(StreamingService::TwitchClient).to receive(:new) { client }
    end

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe 'POST #enqueue' do
    include_context "login_with_user"

    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "", trigger_word_list: ["bar"]) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, user: user, remote_macro_group: remote_macro_group, device: device) }
    let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

    subject { post enqueue_streaming_service_twitch_index_path(streaming_service, "foo", word: param_word) }

    before do
      remote_macro
      streaming_service_account
    end

    context 'monitors_atがに日付が入っているとき' do
      let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service, monitors_at: Time.zone.now) }

      context 'wordがない' do
        let(:param_word) { '' }

        it do
          subject
          expect(response).to be_bad_request
        end

        it do
          subject
          expect(response.body).to eq({"errors"=>"Require word param"}.to_json)
        end
      end

      context 'streaming_service.deviceにnilのとき' do
        let(:device) { nil }
        let(:param_word) { 'bar' }

        it do
          subject
          expect(response).to be_bad_request
        end

        it do
          subject
          expect(response.body).to eq({"errors"=>"Require device of streaming_service"}.to_json)
        end
      end

      context 'streaming_service.remote_macro_groupにnilのとき' do
        let(:param_word) { 'bar' }

        before do
          streaming_service.update!(remote_macro_group: nil)
        end

        it do
          subject
          expect(response).to be_bad_request
        end

        it do
          subject
          expect(response.body).to eq({"errors"=>"Require remote_macro_group of streaming_service"}.to_json)
        end
      end

      context 'wordがある' do
        context 'wordがマッチする' do
          let(:param_word) { 'bar' }

          it do
            subject
            expect(response).to be_ok
          end

          it { expect { subject }.to have_broadcasted_to(device.push_token) }
          it { expect { subject }.to change { device.pbm_remote_macro_jobs.count }.by(1) }
        end

        context 'wordがマッチしない' do
          let(:param_word) { 'no word' }

          it do
            subject
            expect(response).to be_bad_request
          end

          it do
            subject
            expect(response.body).to eq({"errors"=>"The remote_macro did not find"}.to_json)
          end

          it { expect { subject }.not_to have_broadcasted_to(device.push_token) }
          it { expect { subject }.not_to(change { device.pbm_remote_macro_jobs.count }) }
        end
      end
    end
  end
end
