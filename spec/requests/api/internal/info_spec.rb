require 'rails_helper'

RSpec.describe "Api::Internal::Info", type: :request do
  describe 'GET show' do
    subject { get api_internal_info_path }
    it do
      subject
      expect(response).to be_ok
    end

    it do
      subject
      expect(JSON.parse(response.body)).to include("redis_endpoint" => Rails.application.config.x.redis_endpoint)
    end
  end
end
