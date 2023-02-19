require 'rails_helper'

RSpec.describe '/devices/:id/logs', type: :request do
  include_context "login_with_user"
  describe 'GET #show' do
    let(:device) { FactoryBot.create(:device, user: user) }

    subject { get device_logs_path(device.unique_key) }

    context '有効なセッションがないとき' do
      it do
        subject
        expect(response).to be_ok
      end
    end

    context '有効なセッションがあるとき' do
      let!(:pbm_session) { PbmSession.create(uuid: :a, device: device, hostname: "a") }

      it do
        subject
        expect(response).to be_ok
      end

      context 'イベント・ログを持っているとき' do
        let!(:pbm_session_event) { pbm_session.events.create!(event_type: :boot) }

        before do
          Event.event_types.keys.each do |event_type|
            pbm_session.events.create!(event_type: event_type)
          end
        end

        it do
          subject
          expect(response).to be_ok
        end
      end
    end
  end
end
