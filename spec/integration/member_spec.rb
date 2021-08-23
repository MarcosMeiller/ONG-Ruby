require 'swagger_helper'

RSpec.describe 'Members API', type: :request do

  path '/members' do
      get 'List Members' do
          tags 'Members'
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

      post 'Creates a member' do
          tags 'Members'
          consumes 'application/json'
          produces 'application/json'
          security [Bearer: {}]
          parameter name: :Authorization, in: :header, type: :string
          parameter name: :member, in: :body, schema: {
            type: :object,
            properties: {
              id: { type: :integer},
              name: { type: :string },
              description: { type: :string },
              facebookUrl: { type: :string },
              instagramUrl: { type: :string },
              linkedinUrl: { type: :string }
            },
            required: ['name']
          }

          response '200', 'member created' do
            let(:category) { { name: 'Test Member' } }
            examples 'application/json' => {
              id: 1,
              name: 'Test member',
              description: 'Description test',
              facebookUrl: 'facebookUrl.com/member'
            }
            run_test!
          end

          response '400', 'bad request' do
              let(:category) { { description: 'Test member' } }
              examples 'application/json' => {
              message: 'Su categoria no pudo crearse'
              }
              run_test!
            end
          end
      end

    path '/members/{id}' do
      # You'll want to customize the parameter types...
      parameter name: 'id', in: :path, type: :string, description: 'id'

      put 'Update a member' do
        tags 'Members'
        security [Bearer: {}]
        parameter name: :Authorization, in: :header, type: :string
        let(:id) {'1'}
        parameter name: :member, in: :body, schema: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            facebookUrl: { type: :string },
            instagramUrl: { type: :string },
            linkedinUrl: { type: :string }
          }
        }
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
        response '404', 'category not found' do
          let(:id) { 'No se encontró la categoría solicitada' }
          run_test!
        end
      end

      delete 'Delete a member' do
        tags 'Members'
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
        response '404', 'Member not found' do
          let(:id) { 'La categoría no se encontró o ya fue eliminada' }
          run_test!
        end
      end
    end
end
