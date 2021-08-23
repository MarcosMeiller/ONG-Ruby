# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contacts', type: :request do
  let!(:role) { Role.create({ name: 'regular' }) }
  let!(:user) do
    User.create(
      {
        firstName: 'Jose',
        lastName: 'Perez',
        email: 'test@test.com',
        password: 'asdfgh',
        photo: 'pic.png',
        role_id: role.id
      }
    )
  end
  let!(:token) do
    post '/auth/login', params: {
      email: user.email,
      password: 'asdfgh'
    }
    json = JSON.parse(response.body).deep_symbolize_keys
    json[:token]
  end

  describe 'POST /contacts' do
    it 'creates a new contact' do
      post contacts_path,
           params: {
             name: 'Jose',
             email: 'jose@perez.com',
             phone: '0123456',
             message: 'Hello world'
           },
           headers: {
             authorization: "Bearer #{token}"
           }

      expect(response).to have_http_status(201)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:name]).to eq('Jose')
      expect(json[:email]).to eq('jose@perez.com')
      expect(json[:phone]).to eq('0123456')
      expect(json[:message]).to eq('Hello world')
      expect(Contact.last.name).to eq('Jose')
    end

    scenario 'empty name' do
      post contacts_path,
           params: {
             name: '',
             email: 'jose@perez.com',
             phone: '0123456',
             message: 'Hello world'
           },
           headers: {
             authorization: "Bearer #{token}"
           }

      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)

      expect(json).to include("Name can't be blank")
    end

    scenario 'short name' do
      post contacts_path,
           params: {
             name: 'Jo',
             email: 'jose@perez.com',
             phone: '0123456',
             message: 'Hello world'
           },
           headers: {
             authorization: "Bearer #{token}"
           }

      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)

      expect(json).to include('Name is too short (minimum is 3 characters)')
    end

    scenario 'empty email' do
      post contacts_path,
           params: {
             name: 'Jose',
             email: '',
             phone: '0123456',
             message: 'Hello world'
           },
           headers: {
             authorization: "Bearer #{token}"
           }

      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)

      expect(json).to include("Email can't be blank")
    end

    scenario 'invalid email' do
      post contacts_path,
           params: {
             name: 'Jose',
             email: 'asdf',
             phone: '0123456',
             message: 'Hello world'
           },
           headers: {
             authorization: "Bearer #{token}"
           }

      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)

      expect(json).to include('Email is invalid')
    end
  end

  let!(:contact) do
    Contact.create(
      {
        name: 'Jose',
        email: 'jose@perez.com',
        phone: '0123456',
        message: 'Hello world',
        user_id: user.id
      }
    )
  end

  describe 'GET /contacts' do
    it 'shows current user contacts' do
      get contacts_path,
          headers: {
            authorization: "Bearer #{token}"
          }

      expect(response).to have_http_status(200)

      json = JSON.parse(response.body)[0].deep_symbolize_keys
      expect(json[:name]).to eq('Jose')
    end
  end

  describe 'GET /backoffice/contacts' do
    let!(:role_admin) { Role.find(1) }
    let!(:user_admin) do
      User.create(
        {
          firstName: 'Juan',
          lastName: 'Perez',
          email: 'test2@test.com',
          password: 'asdfgh',
          photo: 'pic.png',
          role_id: role_admin.id
        }
      )
    end
    let!(:token_admin) do
      post '/auth/login', params: {
        email: user_admin.email,
        password: 'asdfgh'
      }
      json = JSON.parse(response.body).deep_symbolize_keys
      json[:token]
    end

    it 'shows all contacts' do
      get '/backoffice/contacts',
          headers: {
            authorization: "Bearer #{token_admin}"
          }

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)

      contact1 = json[0].deep_symbolize_keys
      expect(contact1[:name]).to eq('Jose')
    end

    it 'denies access if user not admin' do
      get '/backoffice/contacts',
          headers: {
            authorization: "Bearer #{token}"
          }

      expect(response).to have_http_status(403)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq('You are not authorized')
    end
  end
end
