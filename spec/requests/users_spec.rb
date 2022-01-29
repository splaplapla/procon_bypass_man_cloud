require 'rails_helper'

RSpec.describe "User", type: :request do
  describe "GET /edit" do
    include_context "login_with_user"

    subject { get edit_user_path }

    it do
      subject
      expect(response).to be_ok
    end
  end

  describe "PUT /update" do
    include_context "login_with_user"

    subject { put user_path, params: { user: user_params } }

    let(:user_params) { { email: "changed@example.com" } }

    it do
      subject
      expect(response).to be_redirect
    end

    it do
      expect { subject }.to change { user.reload.email }.to("changed@example.com")
    end
  end

  describe 'GET /new' do
    subject { get new_user_path }

    context 'ログインしているとき' do
      include_context "login_with_user"

      it do
        subject
        expect(response).to be_redirect
      end
    end

    context 'ログインしていないとき' do
      it do
        subject
        expect(response).to be_ok
      end
    end
  end

  describe 'GET /create' do
    subject { post user_path, params: { user: { email: "new@example.com", password: "hoge", password_confirmation: "hoge" } } }

    context 'provide valid params' do
      it do
        subject
        expect(response).to be_redirect
      end

      it do
        subject
        expect(session[:user_id]).to eq(User.last.id.to_s)
      end
    end

    context 'provide invalid params' do
      subject { post user_path, params: { user: { email: "new@example.com", password: "hoge", password_confirmation: "" } } }

      it do
        subject
        expect(response).to be_ok
      end
    end
  end
end
