module ApiDocs::V1
  class ConfigurationsController
    include Swagger::Blocks

    swagger_path '/api/v1/configuration' do
      operation :get do
        key :description, 'Fetches the WebSocket server URL for client-side use'
        key :produces, [
          'application/json'
        ]
        response 200 do
          key :description, 'Successful response'
          schema do
            property :ws_server_url do
              key :type, :string
            end
          end
        end
      end
    end
  end
end
