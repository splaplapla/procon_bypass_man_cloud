class StreamingServicesController < ApplicationController
  def index
    @streaming_services = current_user.
      streaming_services.
      preload(:device, :remote_macro_group).
      order(id: :asc)

    @remote_macro_groups = current_user.remote_macro_groups
  end

  def new
    @streaming_service = current_user.streaming_services.build
  end

  def create
    @streaming_service = current_user.streaming_services.build(streaming_service_param)
    if @streaming_service.save
      redirect_to @streaming_service, notice: "新規作成できました"
    else
      render :new
    end
  end

  def show
    @streaming_service = current_user.streaming_services.find(params[:id])
  end

  def destroy
    @streaming_service = current_user.streaming_services.find(params[:id]).destroy
    redirect_to streaming_services_path, notice: "削除できました"
  end

  private

  def streaming_service_param
    params.require(:streaming_service).permit(
      :name,
      :service_type,
      :remote_macro_group_id,
      :device_id,
    )
  end
end