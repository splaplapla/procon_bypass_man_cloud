class Internal::ProconBypassManVersionsController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def show
    Rails.cache.fetch([device.cache_key, :pong], expires_in: 1.hours) do
      ProconBypassManVersion.fetch_latest_version
    end

    render json: {
      is_latest: ProconBypassManVersion.is_latest?(name: params[:id]),
      latest_version: ProconBypassManVersion.last.name
    }
  end
end
