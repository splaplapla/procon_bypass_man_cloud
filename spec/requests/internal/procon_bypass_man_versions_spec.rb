require 'rails_helper'

RSpec.describe "Internal::ProconBypassManVersions", type: :request do
  before do
    allow(ProconBypassManVersion::Client).to receive(:get_version) { "0.1.1" }
  end

  describe 'GET /show' do
    before do
      ProconBypassManVersion.create!(name: "0.1.1")
      ProconBypassManVersion.create!(name: "0.1.2")
      ProconBypassManVersion.create!(name: "0.1.3")
    end

    it do
      get internal_procon_bypass_man_version_path "0.1.0"
      expect(JSON.parse(response.body)).to eq("is_latest"=>false, "latest_version"=>"0.1.3")
    end

    it do
      get internal_procon_bypass_man_version_path "0.1.2"
      expect(JSON.parse(response.body)).to eq("is_latest"=>false, "latest_version"=>"0.1.3")
    end

    it do
      get internal_procon_bypass_man_version_path "0.1.3"
      expect(JSON.parse(response.body)).to eq("is_latest"=>true, "latest_version"=>"0.1.3")
    end

    it do
      get internal_procon_bypass_man_version_path "0.1.4"
      expect(JSON.parse(response.body)).to eq("is_latest"=>true, "latest_version"=>"0.1.3")
    end
  end
end
