require 'swagger_helper'

RSpec.describe 'News API', type: :request do

    let(:Authorization) { "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNH0.LANmhpfIFYUSWBW61lFOZtBZZKoUs7dlXVjzdo-PdrQ" }

  path '/news' do
    get 'List news' do
        tags 'News'
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

    post 'Creates a new' do
      tags 'News'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :new, in: :body, schema: {
        type: :object,
        properties: {
          new:{ type: :object,
            properties: {
              name: { type: :string },
              content: { type: :string },
              category_id: {type: :integer},
              image: {type: :string}
        } 
      }
      },
        required: ['name','content','category_id','image']
      }
      
      response '200', 'category created' do
        let(:new) { { name: 'Novedad 1', content: 'esta es la novedad 1', image: 'url.png', category_id: 1 } }

        run_test!
      end

      response '400', 'bad request' do
          let(:new) { { content: 'esta es la novedad 1' } }
          examples 'application/json' => {
          message: 'Su novedad no pudo crearse'
          }
          run_test!
        end
      end
  

   
  path '/news/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'
    get 'show new' do
        tags 'News'
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
      response '404', 'new not found' do
        let(:id) { 'No se encontró la Novedad solicitada' }
        run_test!
      end
    end

    put 'update new' do
        tags 'News'
        security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'successful') do
        parameter name: :new, in: :body, schema: {
        type: :object,
        properties: {
          new:{ type: :object,
            properties: {
              name: { type: :string },
              content: { type: :string },
              category_id: {type: :integer},
              image: {type: :string}
        } 
      }
      },
        required: ['name','content','category_id','image']
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
      response '404', 'new not found' do
        let(:id) { 'No se encontró la novedad solicitada' }
        run_test!
      end
    end

    delete 'delete new' do
      tags 'News'
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
      response '404', 'new not found' do
        let(:id) { 'La novedad no se encontró o ya fue eliminada' }
        run_test!
      end
    end
  end
end
end