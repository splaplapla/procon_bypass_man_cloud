class Feature::Splatoon2::SketchesController < ApplicationController
  def index
    @sketches = current_user.splatoon2_sketches
  end

  def new
    @sketch = current_user.splatoon2_sketches.build
  end

  def create
    @sketch = current_user.splatoon2_sketches.build(sketch_params)
    if @sketch.save
      redirect_to feature_splatoon2_sketch_path(@sketch)
    else
      render :new
    end
  end

  def show
    @sketch = current_user.splatoon2_sketches.find(params[:id])
  end

  def destroy
    @sketch = current_user.splatoon2_sketches.find(params[:id])
    @sketch.destroy
    redirect_to feature_splatoon2_sketches_path(@sketch), notice: '削除しました'
  end

  private

  def sketch_params
    params[:splatoon2_sketch].permit(:name, :image)
  end
end
