class Feature::Splatoon2::SketchesController < ApplicationController
  def index
    @sketches = current_user.splatoon2_sketches
  end

  def new
    @sketch = current_user.splatoon2_sketches.build
  end

  def show
    @sketch = current_user.splatoon2_sketches.find(params[:id])
  end

  def edit
    @sketch = current_user.splatoon2_sketches.find(params[:id])
  end

  def update
    @sketch = current_user.splatoon2_sketches.find(params[:id])
    if @sketch.update(sketch_params)
      redirect_to feature_splatoon2_sketch_path(@sketch)
    else
      render :edit
    end
  end

  def create
    @sketch = current_user.splatoon2_sketches.build(sketch_params)
    if @sketch.save
      redirect_to feature_splatoon2_sketch_path(@sketch)
    else
      render :new
    end
  end

  def monochrome_image
    @sketch = current_user.splatoon2_sketches.find(params[:id])
    image_data, file_content_type = @sketch.decoded_image
    converted_image_file = ConvertBinarizationImageService.new(image_data: image_data, file_content_type: file_content_type, threshold: @sketch.binary_threshold || 0).execute
    converted_image_data = Lib::Image2Base64.new(converted_image_file, content_type: file_content_type).execute
    render json: { image_data: converted_image_data }
    converted_image_file.close
  end

  def destroy
    @sketch = current_user.splatoon2_sketches.find(params[:id])
    @sketch.destroy
    redirect_to feature_splatoon2_sketches_path(@sketch), notice: '削除しました'
  end

  private

  def sketch_params
    params[:splatoon2_sketch].permit(:name, :image, :binary_threshold, :crop_data)
  end
end
