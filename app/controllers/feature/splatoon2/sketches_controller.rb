class Feature::Splatoon2::SketchesController < ApplicationController
  before_action :can_create_another_splatoon2_sketches, only: [:new, :create]

  def index
    @sketches = current_user.splatoon2_sketches
  end

  def new
    @sketch = current_user.splatoon2_sketches.build
  end

  def show
    @sketch = get_sketch
  end

  def edit
    @sketch = get_sketch
  end

  def edit_binary_threshold
    @sketch = get_sketch
  end

  def update
    @sketch = get_sketch
    if @sketch.update(sketch_params)
      redirect_to feature_splatoon2_sketch_path(@sketch)
    else
      render :edit
    end
  end

  def create
    unless current_user.can_have_another_splatoon2_sketches?
      raise '登録可能なスケッチを超えています' # TODO サービスクラスにする
    end

    @sketch = current_user.splatoon2_sketches.build(sketch_params)
    if @sketch.save
      redirect_to feature_splatoon2_sketch_path(@sketch)
    else
      render :new
    end
  end

  def monochrome_image
    @sketch = get_sketch
    image_data, file_content_type = @sketch.decoded_image
    binary_threshold = params[:binary_threshold].presence&.to_i || @sketch.binary_threshold || 0
    converted_image_file = Splatoon2SketchService::ConvertBinarizationImageService.new(
      image_data: image_data,
      file_content_type: file_content_type,
      threshold: binary_threshold
    ).execute
    converted_base64_image_data = Lib::Image2Base64.new(converted_image_file, content_type: file_content_type).execute
    render json: { image_data: converted_base64_image_data }
    converted_image_file.close
  end

  def cropped_monochrome_image
    @sketch = get_sketch
    @sketch = Splatoon2SketchConvertWithCropDecorator.new(@sketch)
    image_data, file_content_type = @sketch.decoded_image
    converted_image_file = Splatoon2SketchService::ConvertBinarizationImageWithCropService.new(
      image_data: image_data,
      file_content_type: file_content_type,
      threshold: @sketch.binary_threshold || 0,
      crop_arg: @sketch.crop_arg_of_convert_cmd,
    ).execute
    converted_base64_image_data = Lib::Image2Base64.new(converted_image_file, content_type: file_content_type).execute
    render json: { image_data: converted_base64_image_data }
    converted_image_file.close
  end

  def destroy
    @sketch = get_sketch
    @sketch.destroy
    redirect_to feature_splatoon2_sketches_path(@sketch), notice: '削除しました'
  end

  private

  def sketch_params
    params[:splatoon2_sketch].permit(:name, :image, :binary_threshold, :crop_data)
  end

  def get_sketch
    @sketch ||= current_user.splatoon2_sketches.find(params[:id])
  end

  def can_create_another_splatoon2_sketches
    unless current_user.can_have_another_splatoon2_sketches?
      redirect_to feature_splatoon2_sketches_path
    end
  end
end
