
require 'rails_helper'

RSpec.describe 'MembersController', type: :request do
  # Creacion de rol y usuario para poder acceder a los endpoint
  Role.create({name: 'admin', description: 'admin' })
  let!(:role) { Role.find(1) }
  let!(:role2) { Role.create({ name: 'regular', description: 'regular' }) }
  let!(:user) do
    User.create({ firstName: 'pepe', lastName: 'gege', email: 'pepe@gmail.com', password: '123456', role_id: role.id })
  end
  let!(:user2) do
    User.create({ firstName: 'jose', lastName: 'h', email: 'joseh@gmail.com', password: 'jose', role_id: role2.id })
  end

  let!(:token) do
    post '/auth/login', params: {
      email: user.email,
      password: '123456'
    }
    @json = JSON.parse(response.body).deep_symbolize_keys
    @json[:token]
  end

  describe 'GET #all members' do
    let!(:member) { Member.create({ name: 'miembro 33' }) }
    before { get '/members', headers: { authorization: "Bearer #{token}" } }
   
    scenario 'returns members' do
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
      expect(response).to have_http_status(200)
    end
    describe 'invalid user, not admin' do
      let!(:token2) do
        post '/auth/login', params: {
          email: user2.email,
          password: 'jose'
        }
        @json = JSON.parse(response.body).deep_symbolize_keys
        @json[:token]
      end
      before { get '/members', headers: { authorization: "Bearer #{token2}" } }
      scenario 'returns unauthorized' do
        expect(response).to have_http_status(403)

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:message]).to eq('You are not authorized')
      end
    end
  end

  describe 'POST #create member' do
    scenario 'creates a new member' do
      post members_path,
           params:
               {
                 name: 'miembro 1',
                 description: 'miembro nuevo para hacer testing'
               },
           headers: { authorization: "Bearer #{token}" }
      expect(response).to have_http_status(201)
    end

    scenario 'invalid Member attributes' do
      post members_path,
        params: 
              {
              name: ' ',
              description: 'miembro nuevo para hacer testing'
              },
            headers: { authorization: "Bearer #{token}" }

      expect(response.status).to eq(422)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to eq(["can't be blank"])

      # no new member record is created
      expect(Member.count).to eq(0)
    end
  end

  describe 'PUT members/:id' do
    before(:each) do
      @member = Member.create(name: 'member new')
    end
    scenario 'updates a member' do
      put "#{members_path}/#{@member.id}", params: { name: 'member modificado', description: 'member description' },
                                           headers: { authorization: "Bearer #{token}" }
      expect(response.status).to eq(200)
      expect(Member.last.name).to eq('member modificado')
      expect(Member.last.description).to eq('member description')
    end
    scenario 'not authenticated user' do
      put "#{members_path}/#{@member.id}", params: { name: 'member modificado', description: nil }
      expect(response.status).to eq(401)
    end
  end

  describe 'delete member' do
    before(:each) do
      @member = Member.create(name: 'member new')
    end
    scenario 'should delete member' do
      delete "#{members_path}/#{@member.id}", headers: { authorization: "Bearer #{token}" }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq("Data deleted, but persistent in the database")
    end
  end
end
