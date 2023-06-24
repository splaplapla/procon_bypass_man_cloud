require 'rails_helper'

describe StreamingService::ConvertMessagesToCommandsService do
  let(:user) { FactoryBot.create(:user) }
  let(:device) { FactoryBot.create(:device, user: user, name: "bar") }
  let(:streaming_service) { FactoryBot.create(:streaming_service, user: user, device: device, remote_macro_group: remote_macro_group) }
  let(:streaming_service_account) { FactoryBot.create(:streaming_service_account, streaming_service: streaming_service, monitors_at: Time.zone.now) }
  let(:remote_macro) { FactoryBot.create(:remote_macro, remote_macro_group: remote_macro_group, steps: "x", trigger_word_list: ["煽って"]) }
  let(:remote_macro_group) { FactoryBot.create(:remote_macro_group, user: user) }

  describe 'execute' do
    subject { described_class.new(streaming_service_account, messages: messages).execute }

    before do
      remote_macro
    end

    context '要件を満たしているとき' do
      let(:messages) { [
        # body, :author_channel_id, :author_name, :owner, :moderator, :published_at
        StreamingService::YoutubeLive::ChatMessage.new("!煽って", "a", "taro", false, false, Time.zone.now + 60)
      ] }

      it do
        expect { subject }.to(change { device.pbm_remote_macro_jobs.count })
      end

      it do
        expect(subject.size).to eq(1)
      end
    end

    context 'トリガーワードがないとき' do
      let(:messages) { [
        StreamingService::YoutubeLive::ChatMessage.new("!煽って", "a", "taro", false, false, "2011-11-11 10:00:00".to_time)
      ] }

      it do
        expect { subject }.not_to(change { device.pbm_remote_macro_jobs.count })
      end

      it do
        expect(subject.size).to eq(0)
      end
    end

    context '発言が古いとき' do
      let(:messages) { [
        StreamingService::YoutubeLive::ChatMessage.new("!煽って", "a", "taro", false, false, "2011-11-11 10:00:00".to_time)
      ] }

      it do
        expect { subject }.not_to(change { device.pbm_remote_macro_jobs.count })
      end

      it do
        expect(subject.size).to eq(0)
      end
    end

    context 'モデレーターの発言のとき' do
      let(:messages) { [
        StreamingService::YoutubeLive::ChatMessage.new("!煽って", "a", "taro", false, true, Time.zone.now + 60)
      ] }

      it do
        expect { subject }.not_to(change { device.pbm_remote_macro_jobs.count })
      end

      it do
        expect(subject.size).to eq(0)
      end
    end
  end
end
