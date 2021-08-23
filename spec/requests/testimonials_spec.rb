require 'rails_helper'

RSpec.describe 'TestimonialsController', type: :request do
  let!(:testimonial) { Testimonial.create!(name: 'My Testimonial test', content: 'My testimonial content') }
  Role.create({name: 'admin', description: 'admin' })
  let!(:role) { Role.find(1) }
  let!(:user) do User.create({  firstName: 'test',
                                lastName: 'user',
                                email: 'test@user.com',
                                password: '123456',
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
  let!(:regular_role) { Role.create!({ name: 'regular', description: 'regular user' }) }
  let!(:regular_user) do User.create({  firstName: 'test',
                                lastName: 'useradmin',
                                email: 'testadmin@user.com',
                                password: '123456',
                                role_id: regular_role.id })
  end
  let!(:regular_token) do
    post '/auth/login', params: {
      email: regular_user.email,
      password: '123456'
    }
    @json = JSON.parse(response.body).deep_symbolize_keys
    @json[:token]
  end

  describe '# INDEX' do
    it 'Returns status code 200 with token as header' do
      get '/testimonials', headers:{ authorization: "Bearer #{token}" }
      expect(response).to have_http_status(:success)
    end

    it 'Returns status code 401 without token' do
      get '/testimonials'
      expect(response).to have_http_status(401)
    end

    it 'Avoid access if no admin user' do
      get '/testimonials', headers: { authorization: "Bearer #{regular_token}" }
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq("You are not authorized")
    end

    it 'Get listed the instances of testimonial' do
      get '/testimonials', headers: { authorization: "Bearer #{token}" }
      hash_body = JSON.parse(response.body)
      response = hash_body["testimonials"]["page1"]["testimonials"].first
      expect(response["id"]).to match(testimonial.id)
      expect(response["name"]).to match(testimonial.name)
      expect(response["content"]).to match(testimonial.content)
    end
  end

  describe '# VALIDATIONS' do
  it 'VALIDATIONS: Avoid create a testimonial without required params' do
    testimonial = Testimonial.new
    testimonial.validate
    expect(testimonial.errors[:name]).to include("can't be blank")

    testimonial.name = "Test"
    testimonial.validate
    expect(testimonial.errors[:name]).to_not include("can't be blank")
    expect(testimonial.errors[:name]).to include("is too short (minimum is 6 characters)")

    testimonial.name = "Test name"
    testimonial.validate
    expect(testimonial.errors[:name]).to_not include("can't be blank")
    expect(testimonial.errors[:name]).to_not include("is too short (minimum is 6 characters)")
  end
end
end
