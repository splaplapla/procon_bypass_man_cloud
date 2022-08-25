class Feature::Splatoon2::DrawingSketchesController < ApplicationController
  def show
    @sketch = get_sketch
    @dots = get_dots
  end

  def create
  end

  private

  def get_sketch
    @sketch ||= current_user.splatoon2_sketches.find(params[:sketch_id])
  end

  def get_dots
    @sketch = get_sketch
    @sketch = Splatoon2SketchConvertWithCropDecorator.new(@sketch)
    image_data, file_content_type = @sketch.decoded_image
    converted_image_file = ConvertBinarizationImageWithCropService.new(
      image_data: image_data,
      file_content_type: file_content_type,
      threshold: @sketch.binary_threshold || 0,
      crop_arg: @sketch.crop_arg_of_convert_cmd,
    ).execute

    img = Magick::ImageList.new(converted_image_file.open)
    dots = img.rows.times.map { |y|
      img.columns.times.map { |x|
        color = img.pixel_color(x, y).to_color
        if color == "black"
          "@"
        else
          " "
        end
      }.join
    }.join("<br>").html_safe
    converted_image_file.close
    dots
  end
end
