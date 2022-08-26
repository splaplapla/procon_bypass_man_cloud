class GenerateSplatoon2SketchBinarizationListService
  COLOR_BLACK = "black"

  # @param [File] 2値化した画像のファイル
  def initialize(file: )
    @file = file
  end

  # @return [Array<Array<Boolean>>] trueが黒で、falseが白
  def execute
    img = Magick::ImageList.new(@file.open)
    dots = img.rows.times.map { |y|
      img.columns.times.map { |x|
        img.pixel_color(x, y).to_color == COLOR_BLACK
      }
    }
  end
end
