class Api::Internal::InfosController < Api::Base
  def show
    render json: {
      redis_endpoint: Rails.application.config.x.redis_endpoint,
    }
  end
end
