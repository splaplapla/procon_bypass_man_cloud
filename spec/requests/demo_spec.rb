require 'rails_helper'

RSpec.describe "Demo", type: :request do
  describe "GET /show" do
    subject { get demo_path }

    context 'デモデバイスがあるとき' do
      let(:device) { FactoryBot.create(:device) }

      before do
        device.create_demo_device!
      end

      it do
        subject
        expect(response).to be_ok
      end
    end

    context 'デモデバイスがないとき' do
      it do
        subject
        expect(response).to be_redirect
      end

      context 'ログインユーザで表示するとき' do
        include_context "login_with_admin_user"

        it do
          subject
          expect(response).to be_redirect
        end

        it do
          expect { subject }.to change { session[:user_id] }.to(nil)
        end
      end
    end
  end
end
