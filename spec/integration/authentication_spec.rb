require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  let(:role) { Role.create({ name: 'admin' }) }
  
  
  

  path '/auth/register' do
    post 'Register a new User' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          firstName: { type: :string },
          lastName: { type: :string },
          email: { type: :string },
          password: { type: :string },
          photo: { type: :string },
          role_id: { type: :number },
        },
        required: %w[firstName lastName email password role_id]
      }

      response '201', 'user created' do
        let(:user) {
          { 
            firstName: 'Jose',
            lastName: 'Perez',
            email: 'test@test.com',
            password: 'asdfgh',
            role_id: role.id
          }
        }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { email: 'John'  } }
        run_test!
      end
    end
  end

  path '/auth/login' do

    post 'Login a User' do
      tags 'Auth'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
        },
        required: %w[email password]
      }

      response '200', 'logged in' do
        let(:user) { { email: 'test@test.com', password: 'asdfgh' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:user) { { email: 'asdf', password: 'asdfgh' } }
        run_test!
      end
    end
  end
end
