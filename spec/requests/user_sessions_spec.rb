require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get login_path
      expect(response).to be_ok
    end
  end
end
