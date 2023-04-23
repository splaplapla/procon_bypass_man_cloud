class Api::V1::ConfigurationsController < Api::V1::Base
  def show
    render json: {
      ws_server_url: ActionCableServer.new.url_with_host(host: request.host),
    }
  end
end
