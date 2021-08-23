# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'API ONG V1',
        version: 'v1',
        description: "Esta es la documentacion con swagger para la ong"
      },
      securityDefinitions: {
    Bearer: {
      description: 'introducir "Bearer + token . Example: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNH0.LANmhpfIFYUSWBW61lFOZtBZZKoUs7dlXVjzdo-PdrQ',
      type: :apiKey,
      name: 'Authorization',
      in: :header
    }
  },
      paths: {},
      definitions:{
        Category:{
          type:'object',
          properties: {
            id:          { type: :integer, example: "1"},
            name:        { type: :string, example: "categoria 1"},
            description: { type: :string, example: "esta es la categoria 1"},
            is_deleted:  { type: :boolean, example: "false"}
          }
        },
        Testimonial:{
          type:'object',
          properties: {
            id:          { type: :integer, example: "1"},
            name:        { type: :string, example: "testimonial 1"},
            content:     { type: :string, example: "testimonial content"},
            is_deleted:  { type: :boolean, example: "false"}
          }
        }
      },
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
