class Api::V1::ConfigurationsController < Api::V1::Base
  def show
    render json: {
      ws_server_url: "ws://#{request.host}", # TODO: standalone actioncable にする
    }
  end
end
