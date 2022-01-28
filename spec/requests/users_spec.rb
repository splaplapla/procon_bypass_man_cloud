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
end
