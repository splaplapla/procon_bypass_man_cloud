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

    context 'コメント行があるとき' do
      context '1 row' do
        let(:text) do
          <<~TEXT
          # macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]
          TEXT
        end
        it { is_expected.to be_empty }
      end

      context '2 row with prefix spaces' do
        let(:text) do
          " # macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]\n" +
          " # macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]"
        end
        it { is_expected.to be_empty }
      end
    end

    context 'マクロ行があるとき' do
      let(:text) do
        <<~TEXT
          macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]
        TEXT
      end

      it do
      end
    end


    context '連射の行があるとき' do
      let(:text) do
        <<~TEXT
          flip :zr, if_pressed: :zr, force_neutral: :zl
        TEXT
      end

      it { is_expected.to eq(["ZRを連打"]) }
    end

    it do
    end

    context '複数の連射の行があるとき' do
      let(:text) do
        <<~TEXT
          flip :zr, if_pressed: :zr, force_neutral: :zl
          flip :zr, if_pressed: :zr, force_neutral: :zl
          flip :a, if_pressed: :zr, force_neutral: :zl
        TEXT
      end

      it do
      end
    end


    context 'リマップの行があるとき' do
      let(:text) do
        <<~TEXT
          remap :l, to: :zr
        TEXT
      end

      it do
      end
    end
  end
end
