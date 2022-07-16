class Devices::ProconPerformanceMetricsController < ApplicationController
  def show
    @device = current_user.devices.find_by!(unique_key: params[:device_id])
    @data_list = convert_data
  end

  private

  def convert_data
      # metrics.map { |x| [x.timestamp, x.collected_spans_size] }, name: 'メトリクスの数',
    metrics = ProconPerformanceMetric::ReadService.new.execute(device_uuid: @device.uuid)
    [
      { data: metrics.map { |x| [x.timestamp, x.interval_from_previous_succeed_max] }, name: '1バイパスにかかる最大の時間' },
      { data: metrics.map { |x| [x.timestamp, x.interval_from_previous_succeed_p50] }, name: '1バイパスにかかる中央値の時間' },
      { data: metrics.map { |x| [x.timestamp, x.write_time_max] }, name: 'Switchへ書き込みにかかる最大時間' },
      { data: metrics.map { |x| [x.timestamp, x.write_time_p50] }, name: 'Switchへ書き込みにかかる時間の中央値' },
      { data: metrics.map { |x| [x.timestamp, x.read_time_max] }, name: 'プロコンから読み取りにかかる最大時間' },
      { data: metrics.map { |x| [x.timestamp, x.read_time_p50] }, name: 'プロコンから読み取りにかかる時間の中央値' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_max] }, name: 'プロコンから読み取って、Switchへ書き込みまでにかかる最大時間' },
      { data: metrics.map { |x| [x.timestamp, x.time_taken_p50] }, name: 'プロコンから読み取って、Switchへ書き込みまでにかかる時間の中央値' },
      ]
  end
end
