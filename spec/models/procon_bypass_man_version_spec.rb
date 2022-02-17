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
        expect { subject }.not_to change { ProconBypassManVersion.count }
      end
    end

    context '存在しないバージョンのとき' do
      it do
        expect { subject }.to change { ProconBypassManVersion.count }.by(1)
      end
    end
  end

  describe '.is_latest?' do
    subject { ProconBypassManVersion.is_latest?(name: version_name) }
    context '引数のバージョンが存在しないとき' do
      let(:version_name) { "0.1.3" }
      before do
        ProconBypassManVersion.create!(name: "0.1.1")
        ProconBypassManVersion.create!(name: "0.1.2")
      end

      it do
        expect(subject).to eq(true)
      end
    end

    context '古いバージョンのみが存在するとき' do
      let(:version_name) { "0.1.3" }
      before do
        ProconBypassManVersion.create!(name: "0.1.1")
        ProconBypassManVersion.create!(name: "0.1.2")
        ProconBypassManVersion.create!(name: "0.1.3")
      end

      it do
        expect(subject).to eq(false)
      end
    end

    context '新しいバージョンが存在するとき' do
      let(:version_name) { "0.1.3" }
      before do
        ProconBypassManVersion.create!(name: "0.1.1")
        ProconBypassManVersion.create!(name: "0.1.2")
        ProconBypassManVersion.create!(name: "0.1.3")
        ProconBypassManVersion.create!(name: "0.1.4")
      end

      it do
        expect(subject).to eq(true)
      end
    end
  end
end
