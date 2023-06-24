require 'rails_helper'

describe ProconBypassManVersion, type: :model do
  describe '.fetch_latest_version' do
    before do
      allow(ProconBypassManVersion::Client).to receive(:get_version) { "0.1.1" }
    end

    subject { ProconBypassManVersion.fetch_latest_version }

    context '既に存在するバージョンのとき' do
      before do
        ProconBypassManVersion.fetch_latest_version
      end

      it do
        expect { subject }.not_to(change { ProconBypassManVersion.count })
      end
    end

    context '存在しないバージョンのとき' do
      it do
        expect { subject }.to change { ProconBypassManVersion.count }.by(1)
      end
    end
  end
end
