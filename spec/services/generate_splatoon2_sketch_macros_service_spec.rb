require 'rails_helper'

describe GenerateSplatoon2SketchMacrosService do
  let(:list_in_list) {
    [
      [true, false],
      [true, false],
    ]
  }

  it do
    expect(described_class.new(list_in_list: list_in_list).execute).to eq([
      [[:pressing_a_for_0_5sec, :pressing_right_for_0_5sec], [:pressing_right_for_0_5sec], [:pressing_down_for_0_5sec]],
      [[:pressing_left_for_0_5sec], [:pressing_a_for_0_5sec, :pressing_left_for_0_5sec], [:pressing_down_for_0_5sec]]
    ])
  end
end
