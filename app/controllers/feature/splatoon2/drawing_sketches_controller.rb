class Feature::Splatoon2::DrawingSketchesController < ApplicationController
  skip_forgery_protection only: [:create]

  after_action :close_converted_image_file, only: :show

  def show
    @sketch = get_sketch
    @device = get_device
    @binarization_macros = get_binarization_macros
  end

  def create
    if params[:macros].blank? || !params[:macros].is_a?(Array)
      return head :bad_request
    end

    device = get_device
    remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device, save_record: false).execute(steps: params[:macros].join(","), name: "drawing")
    ActionCable.server.broadcast(device.push_token, PbmRemoteMacroJobSerializer.new(remote_macro_job).attributes)

    head :ok
  end

  private

  # @return [Array<Array<Array<String>>>]
  def get_binarization_macros
    macros = nil
    get_converted_image_file.tap do |converted_image_file|
      binarization_list = GenerateSplatoon2SketchBinarizationListService.new(file: converted_image_file).execute
      macros = GenerateSplatoon2SketchMacrosService.new(list_in_list: binarization_list).execute
    end

    macros
  end

  # @return [Array<Array<String>>]
  # debug用
  def get_asc_art
    asc_art = nil
    get_converted_image_file.tap do |converted_image_file|
      list_in_list = GenerateSplatoon2SketchBinarizationListService.new(file: converted_image_file).execute
      asc_art = list_in_list.map { |in_list|
        in_list.map { |item|
          item ? '@' : ' '
        }.join
      }.join("<br>").html_safe
    end

    asc_art
  end

  # @return [void]
  def close_converted_image_file
    get_converted_image_file.close!
  end

  # @return [File]
  def get_converted_image_file
    if defined?(@converted_image_file)
      @converted_image_file.rewind
      return @converted_image_file
    end

    @sketch = get_sketch
    @sketch = Splatoon2SketchConvertWithCropDecorator.new(@sketch)
    image_data, file_content_type = @sketch.decoded_image
    @converted_image_file = ConvertBinarizationImageWithCropService.new(
      image_data: image_data,
      file_content_type: file_content_type,
      threshold: @sketch.binary_threshold || 0,
      crop_arg: @sketch.crop_arg_of_convert_cmd,
    ).execute
  end

  def get_sketch
    @sketch ||= current_user.splatoon2_sketches.find(params[:sketch_id])
  end

  def get_device
    @device ||= current_user.devices.find_by!(unique_key: params[:device_id])
  end
end
