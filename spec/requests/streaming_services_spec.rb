require 'rails_helper'

RSpec.describe StreamingServicesController, type: :request do
  include_context "login_with_user"

  describe "GET /index" do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }

    before do
      streaming_service
    end

    it do
      get streaming_services_path
      expect(response).to be_ok
    end
  end

  describe "GET /new" do
    it do
      get new_streaming_service_path
      expect(response).to be_ok
    end
  end

  describe "GET /show" do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }

    it do
      get streaming_service_path(streaming_service)
      expect(response).to be_ok
    end
  end

  describe "GET /edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:device) { FactoryBot.create(:device, user: user) }
    let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }
    let(:streaming_service) { FactoryBot.create(:streaming_service, remote_macro_group: remote_macro_group, device: device, user: user) }

    it do
      get edit_streaming_service_path(streaming_service)
      expect(response).to be_ok
    end
  end
end
