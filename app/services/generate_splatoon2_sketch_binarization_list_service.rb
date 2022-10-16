class GenerateSplatoon2SketchBinarizationListService
  COLOR_BLACKS = Set.new([
    "black",
    "#2C1585",
    "7957F0",
    "gray1",
    "gray2",
    "gray3",
    "gray4",
    "gray5",
    "gray6",
    "gray7",
    "gray8",
    "gray9",
  ])

  # @param [File] 2値化した画像のファイル
  def initialize(file: )
    @file = file
  end

  # @return [Array<Array<Boolean>>] trueが黒で、falseが白
  def execute
    img = Magick::ImageList.new(@file.open)
    dots = img.rows.times.map { |y|
      img.columns.times.map { |x|
        COLOR_BLACKS.include?(img.pixel_color(x, y).to_color)
      }
    }
  end
end
