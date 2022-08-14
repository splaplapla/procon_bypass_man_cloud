class DevicesController < ApplicationController
  skip_forgery_protection only: [:ping, :offline]

  def index
    @devices = current_user.devices.order(id: :asc)
  end

  def show
    @device = current_user.devices.find_by!(unique_key: params[:id])
    @latest_loading_config_event = @device.latest_loading_config_event
    @saved_buttons_settings = current_user.saved_buttons_settings.order(id: :asc)
    @current_pbm_session = @device.current_device_status&.pbm_session
    if @latest_loading_config_event
      @saved_buttons_setting_form = SavedButtonsSettingForm.new(event_id: @latest_loading_config_event.id)

      latest_loading_setting_hash = Digest::SHA1.hexdigest(@latest_loading_config_event.body.dig('setting'))
      @same_saved_buttons_settings = current_user.saved_buttons_settings.where(content_hash: latest_loading_setting_hash)
    end
  end

  def new
    @device = current_user.devices.build
  end

  def create
    unless current_user.can_have_another_devices?
      raise '登録可能なデバイス数を超えています' # TODO サービスクラスにする
    end

    uuid = params.required(:device)[:uuid]

    if device = Device.find_by(user_id: nil, uuid: uuid)
      device.update!(user: current_user)
      redirect_to device_path(device.unique_key), notice: "デバイスの登録が完了しました"
    else
      @device = current_user.devices.build
      @error_message = "デバイスが見つかりませんでした"
      render :new
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

    respond_to do |format|
      format.js
    end
  end

  def pbm_upgrade
    device = current_user.devices.find_by!(unique_key: params[:id])
    pbm_job = Admin::PbmJob::CreateChangePbmVersionService.new(device: device).execute(next_version: params[:pbm_version])
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)

    respond_to do |format|
      format.js
    end
  end

  def restore_setting
    device = current_user.devices.find_by!(unique_key: params[:id])
    saved_buttons_setting = current_user.saved_buttons_settings.find_by!(id: params[:saved_buttons_setting_id])
    pbm_job = Admin::PbmJob::CreateRestorePbmSettingJobService.new(
      device: device,
      setting_content: saved_buttons_setting.content,
      setting_name: saved_buttons_setting.name,
    ).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)

    respond_to do |format|
      format.html do
        redirect_to saved_buttons_settings_path, notice: '復元処理を開始しました'
      end
      format.js
    end
  end

  def restore_editable_setting
    device = current_user.devices.find_by!(unique_key: params[:id])
    setting_content = params[:setting_content]
    pbm_job = Admin::PbmJob::CreateRestorePbmSettingJobService.new(
      device: device,
      setting_content: { 'setting' => setting_content }, # TODO settingがnestしているの直す. clientの修正も必要?
      setting_name: 'manual input setting'
    ).execute!
    ActionCable.server.broadcast(device.push_token, PbmJobSerializer.new(pbm_job).attributes)

    respond_to do |format|
      format.html do
        redirect_to saved_buttons_settings_path, notice: '復元処理を開始しました'
      end
      format.js { render :restore_setting }
    end
  end

  def current_status
    @device = current_user.devices.find_by!(unique_key: params[:id])

    respond_to do |format|
      format.js
    end
  end

  # websocketの疎通確認に失敗したら呼ばれる
  def offline
    @device = current_user.devices.find_by!(unique_key: params[:id])
    @device.offline!
    head :ok
  end
end
