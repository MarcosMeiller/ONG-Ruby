require 'rails_helper'

RSpec.describe 'NewsController', type: :request do
  let!(:category) { Category.create(name: 'Test category', description: 'Description') }
  let!(:new) do New.create!(name: 'My new test',
                            content: 'My test content',
                            image: 'test image',
                            category_id: category.id)
  end
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

  describe '# INDEX' do
    it 'Returns status code 200 with token as header' do
      get '/news', headers: { authorization: "Bearer #{token}" }
      expect(response).to have_http_status(:success)
    end

    scenario 'Returns status code 401 without token' do
      get '/news'
      expect(response).to have_http_status(401)
    end

    it 'VALIDATIONS: Avoid create a New' do
      new_object = New.new
      new_object.validate
      expect(new_object.errors[:name]).to include("can't be blank")

      new_object.name = "Test"
      new_object.validate
      expect(new_object.errors[:name]).to_not include("can't be blank")
    end
  end

  describe '# CREATE a New' do
    it 'Should create a new object with correct params' do
      post  news_index_path,
            params: {
              new: { name: 'My new test',
                     content: 'My test content',
                     image: 'test image',
                     category_id: category.id }},
            headers: { authorization: "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to eq('My new test')
      expect(json[:content]).to eq('My test content')
    end

    it 'Should not create a new object without name param' do
      post  news_index_path,
            params: {
              new: { content: 'My test content',
                     image: 'test image',
                     category_id: category.id }},
            headers: { authorization: "Bearer #{token}" }
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to include("can't be blank")
    end

    it 'Should not create a new object without content param' do
      post  news_index_path,
            params: {
              new: { name: 'My new test',
                     image: 'test image',
                     category_id: category.id }},
            headers: { authorization: "Bearer #{token}" }
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:content]).to include("can't be blank")
    end

    it 'Should not create a new object without image param' do
      post  news_index_path,
            params: {
              new: { name: 'My new test',
                     content: 'My test content',
                     category_id: category.id }},
            headers: { authorization: "Bearer #{token}" }
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:image]).to include("can't be blank")
    end
  end

  describe "# UPDATE News" do
    let!(:new) { New.create({ name: 'My new test',
                              content: 'My test content',
                              image: 'test image',
                              category_id: category.id }) }
    it 'Update a new with correct params' do
      put  "/news/#{new.id}",
            params: { new: { name: "New name" }},
            headers: { authorization: "Bearer #{token}" }
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(response.status).to eq(200)
      expect(json[:name]).to eq('New name')
      expect(json[:name]).not_to eq('My test new')
    end
  end

  describe "# DELETE News" do
    let!(:new) { New.create({ name: 'My destroy test',
                              content: 'My test content',
                              image: 'test image',
                             category_id: category.id }) }

    it 'Should delete a new' do
      expect(new[:is_deleted]).to eq(false)
      delete  "/news/#{new.id}",
              headers: { authorization: "Bearer #{token}" }
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(response.status).to eq(200)
      expect(json[:is_deleted]).to eq(true)
      expect(json[:name]).not_to eq('My test new')
    end
  end
end
