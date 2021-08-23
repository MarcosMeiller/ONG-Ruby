# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Activities', type: :request do

  let!(:role) { Role.new({id: 1, name: "admin"}) }
  let!(:user) do
    User.create({
                  firstName: 'Juanka',
                  lastName: 'Bugallo',
                  email: 'juanka@gmail.com',
                  password: '123456',
                  photo: 'pic.png',
                  role_id: role.id
                })
  end

  let!(:token) do
    post '/auth/login',
         params: {
           email: user.email,
           password: '123456'
         }

    json = JSON.parse(response.body).deep_symbolize_keys
    "Bearer #{json[:token]}"
  end

  let!(:header) { { authorization: token } }

  describe 'POST /activities' do
    let!(:activity) do
      { activity: { name: 'activity1', content: 'content activity', image: 'image.png' } }
    end

    it 'create activity' do
      post activities_path,
           params: activity,
           headers: header

      expect(response).to have_http_status(200)
    end

    scenario 'empty name' do
      activity[:activity][:name] = ''
      post activities_path,
           params: activity,
           headers: header
      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)

      expect(json).to include("Name can't be blank")
    end

    scenario 'empty content' do
      activity[:activity][:content] = ''

      post activities_path,
           params: activity,
           headers: header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json).to include("Content can't be blank")
    end

    scenario 'name short' do
      activity[:activity][:name] = 'ac'

      post activities_path,
           params: activity,
           headers: header
      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)
      expect(json).to include('Name is too short (minimum is 6 characters)')
    end

    scenario 'content short' do
      activity[:activity][:content] = 'con'

      post activities_path,
           params: activity,
           headers: header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json).to include('Content is too short (minimum is 6 characters)')
    end

    scenario 'empty image' do
      activity[:activity][:image] = ''

      post activities_path,
           params: activity,
           headers: header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json).to include("Image can't be blank")
    end

    scenario 'not logged in' do
      header[:authorization] = 'adadas'

      post activities_path,
           params: activity,
           headers: header

      expect(response).to have_http_status(401)
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to include('Please log in')
    end
  end

  ##############################################################################################

  describe 'PUT /activities/:id' do
    let!(:activity) do
      Activity.create({ name: 'Actividad 1', content: 'Content activity', image: 'img.png' })
    end

    let!(:update) do
      { activity: { name: 'activity1', content: 'content activity', image: 'image.png' } }
    end

    it 'update activities' do
      put "/activities/#{activity.id}",
          params: update,
          headers: header

      expect(response).to have_http_status(200)
    end

    scenario 'empty name' do
      update[:activity][:name] = ''
      put "/activities/#{activity.id}",
          params: update,
          headers: header
      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)

      expect(json).to include("Name can't be blank")
    end

    scenario 'empty content' do
      update[:activity][:content] = ''

      put "/activities/#{activity.id}",
          params: update,
          headers: header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json).to include("Content can't be blank")
    end

    scenario 'name short' do
      update[:activity][:name] = 'ac'

      put "/activities/#{activity.id}",
          params: update,
          headers: header
      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)
      expect(json).to include('Name is too short (minimum is 6 characters)')
    end

    scenario 'content short' do
      update[:activity][:content] = 'con'

      put "/activities/#{activity.id}",
          params: update,
          headers: header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json).to include('Content is too short (minimum is 6 characters)')
    end

    scenario 'empty image' do
      update[:activity][:image] = ''

      put "/activities/#{activity.id}",
          params: update,
          headers: header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json).to include("Image can't be blank")
    end
  end
end
