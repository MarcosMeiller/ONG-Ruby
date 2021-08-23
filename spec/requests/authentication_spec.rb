
require 'rails_helper'

RSpec.describe 'AuthenticationController', type: :request do
  let!(:role) { Role.create({ name: 'admin', description: 'admin' }) }
  let!(:user) do
    User.create({ firstName: 'pepe', lastName: 'gege', email: 'pepe@gmail.com', password: '123456', role_id: role.id })
  end

  scenario ' returns  a status  of ok  logged in' do
    post '/auth/login', params: {
      email: user.email,
      password: '123456'
    }
    @json = JSON.parse(response.body).deep_symbolize_keys
    expect(@json[:token]).not_to be_nil
    expect(response.status).to eq(200)
  end

  scenario ' returns  a status  401  not email' do
    post '/auth/login', params: {
      email: ' ',
      password: '123456'
    }
    @json = JSON.parse(response.body).deep_symbolize_keys
    @json[:token]
    expect(response.status).to eq(401)
  end
  describe 'invalid authentication' do
    scenario 'returns unathorized when email does not exist' do
      post '/auth/login', params: { email: 'ac@gmail.com', password: 'password' }
      expect(response).to have_http_status(:unauthorized)
    end

    scenario 'returns unauthorized when password is incorrect' do
      post '/auth/login', params: { email: user.email, password: 'incorrect' }
      expect(response).to have_http_status(:unauthorized)
    end

    scenario 'returns unauthorized ,password invalid' do
      post '/auth/login', params: { email: user.email, password: 2424 }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
