require 'rails_helper'

describe GenerateSplatoon2SketchMacrosService do
  let(:list_in_list) {
    [
      [true, false],
      [true, false],
    ]
  }

  it do
    setter_block = proc { |x| x % { dotting_speed: "0_03" } }
    expect(described_class.new(list_in_list: list_in_list, dotting_speed: 0.03).execute).to eq([
      [
        GenerateSplatoon2SketchMacrosService::MACRO_POINT.map(&setter_block), GenerateSplatoon2SketchMacrosService::MACRO_NOT_POINT.map(&setter_block), GenerateSplatoon2SketchMacrosService::MACRO_NEXT_LINE.map(&setter_block)
      ],
      [
        GenerateSplatoon2SketchMacrosService::MACRO_REVERSE_NOT_POINT.map(&setter_block), GenerateSplatoon2SketchMacrosService::MACRO_REVERSE_POINT.map(&setter_block), GenerateSplatoon2SketchMacrosService::MACRO_NEXT_LINE.map(&setter_block)
      ]
    ])
  end
end
