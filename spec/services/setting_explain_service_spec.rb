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

      it { is_expected.to eq(["試合中に左キーに割り当てられている味方へのスーパージャンプのマクロを設定"]) }
    end

    context '連射の行があるとき' do
      let(:text) do
        <<~TEXT
          flip :zr, if_pressed: :zr, force_neutral: :zl
        TEXT
      end

      it { is_expected.to eq(["ZRボタンを連打"]) }
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

      it { is_expected.to eq(["ZRボタンを連打", "Aボタンを連打"]) }
    end


    context 'リマップの行があるとき' do
      let(:text) do
        <<~TEXT
          remap :l, to: :zr
        TEXT
      end

      it { is_expected.to eq(["LボタンをZボタンへリマップ"]) }
    end

    describe 'all' do
      let(:text) do
        <<~TEXT
          fast_return = ProconBypassMan::Plugin::Splatoon2::Macro::FastReturn
          guruguru = ProconBypassMan::Plugin::Splatoon2::Mode::Guruguru

          install_macro_plugin fast_return
          install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey
          install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey
          install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey
          install_macro_plugin ProconBypassMan::Plugin::Splatoon2::Macro::SokuwariForSplashBomb
          install_mode_plugin guruguru

          prefix_keys_for_changing_layer [:zr, :zl, :l]
          set_neutral_position 1906, 1886

          layer :up, mode: :manual do
            disable_macro :all, if_pressed: :a
            disable_macro :all, if_pressed: :zr

            # flip :zr, if_pressed: :zr, force_neutral: :zl
            flip :zr, if_pressed: :zr, force_neutral: :zl
            flip :zl, if_pressed: [:y, :b, :zl]
            flip :a, if_pressed: [:a]
            flip :down, if_pressed: :down
            macro fast_return.name, if_pressed: [:y, :b, :down]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey, if_pressed: [:y, :b, :up]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey, if_pressed: [:y, :b, :right]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::SokuwariForSplashBomb, if_pressed: [:zl, :right]
            remap :l, to: :zr
            left_analog_stick_cap cap: 1100, if_pressed: [:zl, :a], force_neutral: :a
            # open_macro :dacan, steps: [:pressing_r_for_0_03sec, :pressing_r_and_pressing_zl_for_0_1sec], if_tilted_left_stick: true, if_pressed: [:zl]
            # open_macro :dacan, steps: [:pressing_r_for_0_04sec, :pressing_r_and_pressing_zl_for_0_4sec], if_tilted_left_stick: true, if_pressed: [:zl]
            # open_macro :dacan, steps: [:pressing_r_for_0_03sec, :pressing_r_and_pressing_zl_for_0_2sec], if_tilted_left_stick: { threshold: 800 }, if_pressed: [:zl]
            open_macro :shake, steps: [:shake_left_stick_for_0_1sec], if_pressed: [:b, :r]
          end
          layer :right, mode: guruguru.name
          layer :left do
            flip :zl, if_pressed: [:y, :b, :zl]
            flip :a, if_pressed: [:a]
            flip :down, if_pressed: :down
            macro fast_return.name, if_pressed: [:y, :b, :down]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToUpKey, if_pressed: [:y, :b, :up]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToRightKey, if_pressed: [:y, :b, :right]
            macro ProconBypassMan::Plugin::Splatoon2::Macro::JumpToLeftKey, if_pressed: [:y, :b, :left]
            remap :l, to: :zr
          end
          layer :down do
            # flip :zl
            # flip :zr, if_pressed: :zr, force_neutral: :zl, flip_interval: "1F"
            remap :l, to: :zr
          end
        TEXT
      end

      it do
        is_expected.to eq([
          "ZRボタンを連打",
          "ZLボタンを連打",
          "Aボタンを連打",
          "DOWNボタンを連打",
          "LボタンをZボタンへリマップ",
          "試合中に上キーに割り当てられている味方へのスーパージャンプのマクロを設定",
          "試合中に右キーに割り当てられている味方へのスーパージャンプのマクロを設定",
          "試合中に左キーに割り当てられている味方へのスーパージャンプのマクロを設定",
          "バブル即割のマクロを設定",
        ])
      end
    end
  end
end
