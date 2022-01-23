class DevicesController < ApplicationController
  def index
    @devices = current_user.devices
  end

  def show
    @device = current_user.devices.find_by!(unique_key: params[:id])
    @latest_loading_config_event = @device.latest_loading_config_event
    if @latest_loading_config_event
      @saved_buttons_setting_form = SavedButtonsSettingForm.new(event_id: @latest_loading_config_event.id)
    end
  end

  def update_name
    @device = current_user.devices.find_by!(unique_key: params[:id])
    if @device.update(name: params[:device_name])
      redirect_to device_path(@device.unique_key), notice: "デバイスの名前を変更できました"
    else
      redirect_to device_path(@device.unique_key), alert: "デバイスの名前を変更できませんでした"
    end
  end

  # pingを叩くと、device(pbm)へwebsocket経由で送信する
  # device(pbm)で受信すると、 device(pbm)から`PbmJobChannel#pong` へ送信する
  # PbmJobChannel#pongからwebへ送信する
  def ping
    device = current_user.devices.find_by!(unique_key: params[:id])
    ActionCable.server.broadcast(device.push_token, { action: :ping })
    head :ok
  end

  def restart
    device = current_user.devices.find_by!(unique_key: params[:id])
    pbm_job = Admin::PbmJob::CreateRebootOsService.new(device: device).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)
    redirect_to device_path(device.unique_key), notice: "デバイスの再起動処理を開始しました"
  end

  def pbm_upgrade
    # TODO
  end

  def restore_setting
    device = current_user.devices.find_by!(unique_key: params[:id])
    form = Admin::PbmJob::CreateRestorePbmSettingForm.new(user_id: current_user.id, saved_buttons_setting_id: params[:saved_buttons_setting_id])
    form.validate!
    pbm_job = Admin::PbmJob::CreateRestorePbmSettingJobService.new(device: device, saved_buttons_setting: form.saved_buttons_setting).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)
    redirect_to device_path(device.unique_key), notice: "設定ファイルの復元処理を開始しました"
  end

  def current_status
    @device = current_user.devices.find_by!(unique_key: params[:id])
    respond_to do |format|
      format.js
    end
  end
end
