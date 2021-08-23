require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do

    let(:Authorization) { "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNH0.LANmhpfIFYUSWBW61lFOZtBZZKoUs7dlXVjzdo-PdrQ" }

  path '/categories' do
    get 'List categories' do
        tags 'Categories'
        consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post 'Creates a category' do
        tags 'Categories'
        consumes 'application/json'
        produces 'application/json'
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        parameter name: :category, in: :body, schema: {
          type: :object,
          properties: {
            id: { type: :integer},
            name: { type: :string },
            description: { type: :string }
          },
          required: ['name']
        }
        
        response '200', 'category created' do
          let(:category) { { name: 'Categoria 1', description: 'esta es la categoria 1' } }
          examples 'application/json' => {
            id: 1,
            name: 'Categoria 1',
            description: 'esta es la categoria 1'
          }
          run_test!
        end

        response '400', 'bad request' do
            let(:category) { { description: 'esta es la categoria 1' } }
            examples 'application/json' => {
            message: 'Su categoria no pudo crearse'
            }
            run_test!
          end
        end
    end

  path '/categories/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'
    get 'show category' do
        tags 'Categories'
        security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response '404', 'category not found' do
        let(:id) { 'No se encontró la categoría solicitada' }
        run_test!
      end
    end

    put 'update category' do
        tags 'Categories'
        security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        parameter name: :category, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            description: { type: :string }
          },
          required: ['name'] 
        }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response '404', 'category not found' do
        let(:id) { 'No se encontró la categoría solicitada' }
        run_test!
      end
    end

    delete 'delete category' do
      tags 'Categories'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response '404', 'category not found' do
        let(:id) { 'La categoría no se encontró o ya fue eliminada' }
        run_test!
      end
    end
  end
end