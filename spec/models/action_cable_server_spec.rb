require 'rails_helper'

RSpec.describe ActionCableServer, type: :model do
  describe '#url' do
    subject { described_class.new(action_cable_url: action_cable_url).url }

    context 'when action_cable_url is null' do
      let(:action_cable_url) { nil }

      it do
        expect(subject).to eq('/websocket')
      end
    end

    context 'when action_cable_url is not null' do
      let(:action_cable_url) { 'ws://hoge.com/foo' }

      it do
        expect(subject).to eq('ws://hoge.com/foo')
      end
    end
  end

  describe '#url_with_host' do
    subject { described_class.new(action_cable_url: action_cable_url).url_with_host(host: 'foo.net') }

    context 'when action_cable_url is null' do
      let(:action_cable_url) { nil }

      it do
        expect(subject).to eq('ws://foo.net/websocket')
      end
    end

    context 'when action_cable_url is not null' do
      let(:action_cable_url) { 'ws://hoge.com/foo' }

      it do
        expect(subject).to eq('ws://hoge.com/foo')
      end
    end

    context 'when action_cable_url is not null2' do
      let(:action_cable_url) { 'wss://hoge.com/foo' }

      it do
        expect(subject).to eq('wss://hoge.com/foo')
      end
    end
  end
end
