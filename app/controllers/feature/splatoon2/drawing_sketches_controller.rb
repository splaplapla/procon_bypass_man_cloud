class Feature::Splatoon2::DrawingSketchesController < ApplicationController
  def show
    @sketch = get_sketch
    @asc_art = get_asc_art
  end

  def create
  end

  private

  def get_sketch
    @sketch ||= current_user.splatoon2_sketches.find(params[:sketch_id])
  end

  def get_asc_art
    @sketch = get_sketch
    @sketch = Splatoon2SketchConvertWithCropDecorator.new(@sketch)
    image_data, file_content_type = @sketch.decoded_image
    asc_art = nil
    ConvertBinarizationImageWithCropService.new(
      image_data: image_data,
      file_content_type: file_content_type,
      threshold: @sketch.binary_threshold || 0,
      crop_arg: @sketch.crop_arg_of_convert_cmd,
    ).execute.tap do |converted_image_file|
      list_in_list = GenerateSplatoon2SketchBinarizationListService.new(file: converted_image_file).execute
      asc_art = list_in_list.map { |in_list|
        in_list.map { |item|
          item ? '@' : ' '
        }.join
      }.join("<br>").html_safe
      converted_image_file.close
    end

    asc_art
  end
end
