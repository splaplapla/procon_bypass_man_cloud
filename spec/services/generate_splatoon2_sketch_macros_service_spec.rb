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
      [
        GenerateSplatoon2SketchMacrosService::MACRO_POINT, GenerateSplatoon2SketchMacrosService::MACRO_NOT_POINT, GenerateSplatoon2SketchMacrosService::MACRO_NEXT_LINE
      ],
      [
        GenerateSplatoon2SketchMacrosService::MACRO_REVERSE_NOT_POINT, GenerateSplatoon2SketchMacrosService::MACRO_REVERSE_POINT, GenerateSplatoon2SketchMacrosService::MACRO_NEXT_LINE
      ]
    ])
  end
end
