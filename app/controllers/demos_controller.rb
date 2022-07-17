class DemosController < ApplicationController
  skip_before_action :require_login, only: [:show, :procon_performance_metric]

  before_action :on_mode_mode, only: [:show, :procon_performance_metric]
  before_action :require_demo_device, only: [:show, :procon_performance_metric]
  before_action :must_logout, only: [:show, :procon_performance_metric]

  def show
    @device = target_device
    @saved_buttons_settings = [
      "スマブラ用",
      "[スプラ] ボトル",
      "[スプラ] パブロ",
      "ニンジャラ用",
      "APEX用",
    ].map { |x| SavedButtonsSetting.new(name: x) }
    @latest_loading_config_event = @device.latest_loading_config_event
    if @latest_loading_config_event
      @saved_buttons_setting_form = SavedButtonsSettingForm.new(event_id: @latest_loading_config_event.id)
    end
    render "devices/show"
  end

  def procon_performance_metric
    @device = target_device
    metrics = ProconPerformanceMetric::ReadService.new.execute(device_uuid: @device.uuid)
    @read_time_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.read_time_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.read_time_p50] }, name: '中央値' },
      ]
    @write_time_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.write_time_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.write_time_p50] }, name: '中央値' },
    ]
    @read_write_time_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.time_taken_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p50] }, name: '中央値' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p95] }, name: 'P95' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p99] }, name: 'P99' },
    ]
    @bypass_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.interval_from_previous_succeed_max] }, name: '最大' },
      { data: metrics.map { |x| [x.timestamp, x.interval_from_previous_succeed_p50] }, name: '中央値' },
    ]
    @bypass_count_data_list = [
      { data: metrics.map { |x| [x.timestamp, x.collected_spans_size] }, name: '合計' },
    ]
    render "devices/procon_performance_metrics/show"
  end

  private

  def on_mode_mode
    @is_demo = true
  end

  def require_demo_device
    return redirect_to root_url, alert: "デモページを表示できませんでした" if target_device.nil?
  end

  # @param [Device, NilClass]
  def target_device
    return @target_device if defined?(@target_device)
    @target_device = Device.joins(:demo_device).first
    return @target_device
  end

  # ログインしていると表示がおかしくなるかも。単純化したいのでログアウトする
  def must_logout
    logout
  end
end
