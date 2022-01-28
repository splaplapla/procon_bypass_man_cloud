require 'rails_helper'

RSpec.describe "Root", type: :request do
  describe "GET /index" do
    context 'ログインしていないとき' do
      it  do
        get root_path
        expect(response).to be_ok
      end
    end
  end
end
