require 'rails_helper'

describe SettingExplainService do
  describe '#execute' do
    subject { described_class.new(text: text).execute }
    context 'when blank string' do
      let(:text) { "" }
      it { is_expected.to be_empty }
    end

    context 'when nil' do
      let(:text) { "" }
      it { is_expected.to be_empty }
    end
  end
end
