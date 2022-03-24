require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :request do
  include_context "login_with_user"

  describe 'GET #google_oauth2' do
    let(:user) { FactoryBot.create(:user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, user: user) }

    subject { get "/auth/google_oauth2/callback" }

    before do
      allow_any_instance_of(OmniauthCallbacksController).to receive(:auth_hash) {
        info = OpenStruct.new(name: "bar", image: "foo")
        credentials = OpenStruct.new(token: "bar_token",
                                     refresh_token: "foo",
                                     expires_at: Time.zone.now.to_i)

        OpenStruct.new(
          uid: "foo",
          info: info,
          credentials: credentials,
        )
      }

      allow_any_instance_of(OmniauthCallbacksController).to receive(:current_streaming_service_id) { streaming_service.id }
    end

    context 'すでにアカウントが登録済みのとき' do
      let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service) }

      before do
        streaming_service_account
      end

      it do
        expect { subject }.not_to change { streaming_service.reload_streaming_service_account.id }
      end

      it do
        subject
        expect(response).to be_redirect
      end
    end

    it do
      expect { subject }.not_to change { streaming_service.reload_streaming_service_account }
    end

    it do
      subject
      expect(response).to be_redirect
    end
  end
end
