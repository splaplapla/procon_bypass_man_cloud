class DevicesController < ApplicationController
  def index
    @devices = current_user.devices
  end

  def show
    @device = current_user.devices.find_by!(unique_key: params[:id])
  end

  def update_name
    @device = current_user.devices.find_by!(unique_key: params[:id])
    if @device.update(name: params[:device_name])
      redirect_to device_path(@device.unique_key), notice: "デバイスの名前を変更できました"
    else
      redirect_to device_path(@device.unique_key), alert: "デバイスの名前を変更できませんでした"
    end
  end
end
