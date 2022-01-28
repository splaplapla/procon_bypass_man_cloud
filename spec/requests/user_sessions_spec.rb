require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "GET /new" do
    it do
      get login_path
      expect(response).to be_ok
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
