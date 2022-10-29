class GenerateSplatoon2SketchBinarizationListService
  # @param [File] 2値化した画像のファイル
  def initialize(file: )
    @file = file
  end

  # @return [Array<Array<Boolean>>] trueが黒で、falseが白
  def execute
    img = Magick::ImageList.new(@file.open)
    # img_depth = img.depth NOTE: pngを与えると、to_colorでinvalid depeth(1) エラーになるのでハードコードする
    img_depth = 8
    dots = img.rows.times.map { |y|
      img.columns.times.map { |x|
        color = img.pixel_color(x, y).to_color(Magick::AllCompliance, false, img_depth, true)
        # Rails.logger.info "color: #{color}"
        is_black?(color)
      }
    }
  end

  private

  # @return [[Integer, Integer, Integer]] RGB
  def to_rgb(color)
    hex = color.remove(/^#/)
    r, g, b = hex[0..1], hex[2..3], hex[4..5]
    [r, g, b].map(&:hex)
  end

  # @return [Boolean]
  def is_black?(color)
    to_rgb(color).uniq.first < 120
  end
end
