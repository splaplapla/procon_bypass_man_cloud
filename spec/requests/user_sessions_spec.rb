require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "GET /new" do
    it do
      get login_path
      expect(response).to be_ok
    end
  end

  describe 'POST /create' do
    subject { post login_path, params: { email: email, password: password } }

    context 'ログインに失敗するとき' do
      let(:email) { "jjjjjjjj" }
      let(:password) { "jjjjjjjj" }

      it do
        subject
        expect(response).to be_ok
      end

      it do
        subject
        expect(session["user_id"]).to be_nil
      end
    end

    context 'ログインに成功するとき' do
      let(:user) { FactoryBot.create(:user) }
      let(:email) { user.email }
      let(:password) { "secret" }

      it do
        subject
        expect(response).to be_redirect
      end

      it do
        subject
        expect(session["user_id"]).to eq(user.id.to_s)
      end
    end
  end

  describe 'POST /destroy' do
    include_context "login_with_user"

    subject { post logout_path }

    context 'ログインしているとき' do
      it do
        subject
        expect(response).to be_redirect
      end

      it do
        expect { subject }.to change { session["user_id"] }.to(nil)
      end
    end
  end
end
