class Feature::Splatoon2::DrawingSketchesController < ApplicationController
  skip_forgery_protection only: [:create]

  before_action :require_trim_area, only: [:show, :create]

  after_action :close_converted_image_file, only: :show

  DEFAULT_DOTTING_SPEED = "0.06"

  def show
    @sketch = get_sketch
    @device = get_device
    @dotting_speed = get_dotting_speed
    @flatten_binarization_macros = get_binarization_macros.flatten
    if params[:debug]
      @asc_art = get_asc_art
    end
  end

  def create
    if !params[:macros].is_a?(Array) || params[:macros]&.reject(&:blank?).blank?
      return head :bad_request
    end

    device = get_device
    remote_macro_job = RemoteMacro::CreatePbmRemoteMacroJobService.new(device: device).execute(steps: params[:macros].join(","), name: "drawing")
    remote_macro_job = PbmRemoteMacroJobSerializer.new(remote_macro_job)
    ActionCable.server.broadcast(device.push_token, remote_macro_job.attributes)
    render json: remote_macro_job.to_json
  end

  private

  # @return [Array<Array<String>>]
  def get_binarization_macros
    macros = nil
    get_converted_image_file.tap do |converted_image_file|
      binarization_list = GenerateSplatoon2SketchBinarizationListService.new(file: converted_image_file).execute
      macros = GenerateSplatoon2SketchMacrosService.new(list_in_list: binarization_list, dotting_speed: get_dotting_speed).execute
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
          item ? 'x' : ' '
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
    @converted_image_file = Splatoon2SketchService::ConvertBinarizationImageWithCropService.new(
      image_data: image_data,
      file_content_type: file_content_type,
      threshold: @sketch.binary_threshold || 0,
      crop_arg: @sketch.crop_arg_of_convert_cmd,
    ).execute
  end

  def require_trim_area
    @sketch = get_sketch
    if @sketch.crop_data.blank?
      redirect_to feature_splatoon2_sketch_path(@sketch), alert: '切り取り範囲が登録されていないので、デバイスに送信できません。'
    end
  end

  def get_sketch
    @sketch ||= current_user.splatoon2_sketches.find(params[:sketch_id])
  end

  def get_device
    @device ||= current_user.devices.find_by!(unique_key: params[:device_id])
  end

  def get_dotting_speed
    # ユーザからの入力なのでto_fで悪意のある入力を潰す
    params[:dotting_speed]&.to_f.&to_s || DEFAULT_DOTTING_SPEED
  end
end
