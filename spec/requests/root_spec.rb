require 'rails_helper'

RSpec.describe "Root", type: :request do
  describe "GET /index" do
    context 'ログインしているとき' do
      include_context "login_with_user"

      it  do
        get root_path
        expect(response).to be_redirect
      end
    end

    context 'ログインしていないとき' do
      it  do
        get root_path
        expect(response).to be_ok
      end
    end
  end
end
