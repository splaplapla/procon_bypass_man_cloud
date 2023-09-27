module ApiDocs::V1
  class Root
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'backend'
        contact do
          key :name, 'backend'
        end
      end
    end
  end
end

