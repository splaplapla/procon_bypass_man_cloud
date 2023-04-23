require 'rails_helper'

describe Api::V1::ConfigurationsController, type: :request do
  describe 'GET #show' do
    subject { get api_v1_configuration_path }

    it do
      subject
      expect(response).to be_ok
      expect(response.body).to eq({ "ws_server_url"=> "ws://www.example.com/websocket" }.to_json)
    end
  end
end
