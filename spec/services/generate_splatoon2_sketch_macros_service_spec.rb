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
      [[:pressing_a_for_1sec, :pressing_right_for_1sec], [:pressing_right_for_1sec], [:pressing_down_for_1sec]],
      [[:pressing_left_for_1sec], [:pressing_a_for_1sec, :pressing_left_for_1sec], [:pressing_down_for_1sec]]
    ])
  end
end
