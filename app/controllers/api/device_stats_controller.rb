class Api::DeviceStatsController < Api::Base
  def create
  end

  private

  def event_params
    params.permit(:stats)
  end
end
