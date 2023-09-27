# include Swagger::Blocks

namespace :open_api do
  desc "OpenApiのドキュメント作成"
  task create_document: :environment do
    swaggered_classes = [
      ApiDocs::V1::Root,
      ApiDocs::V1::ConfigurationsController,
    ]
    swagger_data = Swagger::Blocks.build_root_json(swaggered_classes)
    pretty_swagger_data = JSON.pretty_generate(swagger_data)
    File.open('swagger/v1/swagger.json', 'w') { |file| file.write(pretty_swagger_data) }
  end
end
