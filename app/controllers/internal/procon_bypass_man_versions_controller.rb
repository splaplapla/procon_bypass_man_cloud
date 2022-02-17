class Internal::ProconBypassManVersionsController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def show
    # 問い合わせは遅いのでキャッシュする
    Rails.cache.fetch([:pbm_version], expires_in: 1.hours) do
      ProconBypassManVersion.fetch_latest_version
    end

    render json: ProconBypassManVersion.latest(name: params[:id])
  end
end
