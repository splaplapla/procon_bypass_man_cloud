require 'rails_helper'

RSpec.describe "/api/devices/:device_id/device_statuses", type: :request do
  let(:device) { Device.create(uuid: :a, hostname: "aa") }

  describe 'POST /' do
    subject { post api_device_device_statuses_path(device.uuid), params: params }

    context 'statsを渡さないとき' do
      let(:params) { {} }

      it do
        subject
        expect(response.body).to eq({ "errors":["Stats can't be blank"] }.to_json)
      end
    end

    context '定義にないstatsを渡すとき' do
      let(:params) { { stats: "undefined" } }

      it do
        subject
        expect(response.body).to eq({ "errors":["Stats is invalid"] }.to_json)
      end
    end

    context '定義にあるstatsを渡すとき' do
      context 'when running' do
        let(:params) { { stats: "running" } }

        it do
          subject
          expect(response).to be_ok
        end

        it do
          expect { subject }.to change { device.device_statuses.count }.by(1)
        end
      end
    end
  end
end
