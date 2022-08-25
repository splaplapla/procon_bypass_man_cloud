class Splatoon2SketchConvertWithCropDecorator
  def initialize(sketch)
    @sketch = sketch
  end

  def crop_arg_of_convert_cmd
    x = @sketch.crop_data["x"].to_i
    y = @sketch.crop_data["y"].to_i
    width = @sketch.crop_data["width"].to_i
    height = @sketch.crop_data["height"].to_i
    "-crop #{width}x#{height}+#{x}+#{y}"
  end

  private

  def method_missing(name, *args)
    @sketch.send(name, *args)
  end
end
