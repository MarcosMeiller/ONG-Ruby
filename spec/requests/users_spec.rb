require 'rails_helper'

RSpec.describe 'UsersController', type: :request do
  
  Role.create({name: 'admin', description: 'admin' })
  let!(:role) { Role.find(1) }

  let!(:user) do
    User.create({ firstName: 'marcos', lastName: 'meiller', email: 'meiller@gmail.com', password: '123456',
                  role_id: role.id })
  end

  let!(:token) do
    post '/auth/login', params: {
      email: user.email,
      password: '123456'
    }

    @json = JSON.parse(response.body).deep_symbolize_keys
    @json[:token]
  end

  describe 'POST auth/register' do
    it 'creates a new user' do
      post '/auth/register',
           params:
               {
                 firstName: 'newUser',
                 lastName: 'lastnameUser',
                 email: 'email@gmail.com',
                 password: '1234567',
                 role_id: role.id
               }

      expect(response).to have_http_status(201)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:user][:firstName]).to eq('newUser')

      expect(json[:user][:lastName]).to eq('lastnameUser')

      expect(json[:user][:email]).to eq('email@gmail.com')

      expect(User.last.email).to eq('email@gmail.com')
    end

    scenario 'creates a new user without email' do
      post '/auth/register',
           params:
               {
                 firstName: 'newUser',
                 lastName: 'lastnameUser',
                 email: '',
                 password: '1234567',
                 role_id: role.id
               }
      expect(response).to have_http_status(404)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:error]).to eq('not registered')
    end
    scenario 'creates a new user without password' do
      post '/auth/register',
           params:
               {
                 firstName: 'newUser',
                 lastName: 'lastnameUser',
                 email: 'email@gmail.com',
                 password: '',
                 role_id: role.id
               }
      expect(response).to have_http_status(404)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:error]).to eq('not registered')
    end

    scenario 'creates a new user without FirstName' do
      post '/auth/register',
           params:
               {
                 firstName: '',
                 lastName: 'lastnameUser',
                 email: 'email@gmail.com',
                 password: 'password',
                 role_id: role.id
               }

      expect(response).to have_http_status(404)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:error]).to eq('not registered')
    end
  end

  describe 'GET /auth/me' do
    it 'shows perfil user' do
      get '/auth/me',
          headers: {

            authorization: "Bearer #{token}"

          }

      expect(response).to have_http_status(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:email]).to eq('meiller@gmail.com')
    end
  end

  describe 'GET /users' do
    it 'shows all users' do
      get '/users',
          headers: {

            authorization: "Bearer #{token}"

          }

      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)[0].deep_symbolize_keys

      expect(json[:email]).to eq('meiller@gmail.com')
    end
  end

  describe 'PATCH /users/:id' do
    it 'shows perfil user' do
      patch "/users/#{user.id}",
            params:
                  {
                    firstName: 'editUser',
                    lastName: 'editUser',
                    email: 'editUser@gmail.com',
                    password: 'new password',
                    role_id: role.id
                  },

            headers: {

              authorization: "Bearer #{token}"

            }

      expect(response).to have_http_status(200)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:email]).to eq('editUser@gmail.com')
    end

    scenario 'update user with blank email' do
      patch "/users/#{user.id}",
            params:
                  {
                    firstName: 'editUser',
                    lastName: 'editUser',
                    email: '',
                    password: 'new password',
                    role_id: role.id
                  },

            headers: {

              authorization: "Bearer #{token}"

            }

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json[0]).to eq("Email can't be blank")
      expect(json[1]).to eq('Email is invalid')
    end

    scenario 'update user with blank password' do
      patch "/users/#{user.id}",
            params:
                  {
                    firstName: 'editUser',
                    lastName: 'editUser',
                    email: 'emailedit@gmail.com',
                    password: '',
                    role_id: role.id
                  },

            headers: {

              authorization: "Bearer #{token}"

            }

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json[0]).to eq("Password can't be blank")
    end

    scenario 'update user with blank firstName' do
      patch "/users/#{user.id}",
            params:
                  {
                    firstName: '',
                    lastName: 'editUser',
                    email: 'emailedit@gmail.com',
                    password: 'password',
                    role_id: role.id
                  },

            headers: {

              authorization: "Bearer #{token}"

            }

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json[0]).to eq("Firstname can't be blank")
    end
  end

  describe 'DELETE /users/:id' do
    it 'delete user' do
      delete "/users/#{user.id}",
             headers: {

               authorization: "Bearer #{token}"

             }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('Data deleted, but persistent in the database')
    end
  end
end
