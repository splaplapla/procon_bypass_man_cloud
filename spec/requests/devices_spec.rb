require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe "GET /index" do
    context 'ログインしている' do
      include_context "login_with_admin_user"

      it do
        get devices_path
        expect(response).to be_ok
      end
    end

    context 'ログインしていない' do
      it  do
        get devices_path
        expect(response).to be_redirect
      end
    end
  end
end
