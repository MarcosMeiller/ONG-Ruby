require 'rails_helper'

RSpec.describe 'OrganizationsController',type: :request do
      Role.create({name: 'admin', description: 'admin' })
      let!(:role) { Role.find(1) }
      let!(:user){User.create({firstName:'marcos',lastName:'meiller',email:'meiller@gmail.com',password:'123456',role_id:role.id})}
      
      let!(:token) do
        post '/auth/login', params: {
            email:user.email,
            password: '123456'
        }
        
        @json = JSON.parse(response.body).deep_symbolize_keys
        @json[:token]
    end
    describe 'getAll' do

        it 'returns status code 200' do
          get '/organizations/public', headers:{ authorization: "Bearer #{token}" }
          
          expect(response).to have_http_status(200)
        end

        scenario 'without token' do
          get '/organizations/public'

          expect(response).to have_http_status(401)
          json = JSON.parse(response.body).deep_symbolize_keys
          expect(json[:message]).to eq('Please log in')
        end
    end

    describe "PUT /organizations/public/:id" do
      let!(:organization){Organization.create({name: "pepeff", email: "email@gmail.com", welcomeText: "textofff"})}

        it 'updates a organizations' do
        post "/organizations/public/#{organization.id}", params: { name: "modificado", email: "modifiqued@gmail.com", welcomeText: "texto de bienvenida modificado"},
  
        headers:{ authorization: "Bearer #{token}"}
        json = JSON.parse(response.body).deep_symbolize_keys
        
        expect(response.status).to eq(200)

        expect(json[:object][:name]).to eq('modificado')

        expect(json[:object][:email]).to eq('modifiqued@gmail.com')

        expect(json[:object][:welcomeText]).to eq('texto de bienvenida modificado')
        end

        scenario 'updates organization with bad params' do
        post "/organizations/public/#{organization.id}", params: { name: "", email: "modi", welcomeText: "do"},
  
        headers:{ authorization: "Bearer #{token}"}
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json[0]).to eq("Name can't be blank")
        expect(json[1]).to eq("Name is too short (minimum is 6 characters)")
        expect(json[2]).to eq("Email is invalid")
        expect(json[3]).to eq("Welcometext is too short (minimum is 6 characters)")
        end

        scenario 'updates organization with blank name' do
          post "/organizations/public/#{organization.id}", params: { name: "", email: "modificado@gmail.com", welcomeText: "para probar modificacion"},
    
          headers:{ authorization: "Bearer #{token}"}
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          expect(json[0]).to eq("Name can't be blank")
          expect(json[1]).to eq("Name is too short (minimum is 6 characters)")          end

          scenario 'updates organization with blank email' do
            post "/organizations/public/#{organization.id}", params: { name: "modificado", email: " ", welcomeText: "para probar modificacion"},
      
            headers:{ authorization: "Bearer #{token}"}
            expect(response.status).to eq(422)
            json = JSON.parse(response.body)
            expect(json[0]).to eq("Email can't be blank")
            expect(json[1]).to eq("Email is invalid")
            end

          
            scenario 'updates with blank WelcomeText' do
              post "/organizations/public/#{organization.id}", params: { name: "modificado", email: "emailmodificado@gmail.com", welcomeText: ""},
        
              headers:{ authorization: "Bearer #{token}"}
              expect(response.status).to eq(422)
              json = JSON.parse(response.body)
              expect(json[0]).to eq("Welcometext can't be blank")
              expect(json[1]).to eq("Welcometext is too short (minimum is 6 characters)")
            end
    end

    describe 'POST #create organization' do
        it 'creates a new organization'do 
            post organizations_path,
                params: 
                    {
                    name:'new organization',
                    welcomeText:'New welcomeText',
                    email: 'email@gmail.com'
                    },
                    headers:{ authorization: "Bearer #{token}"}
            expect(response).to have_http_status(200)
                
            json = JSON.parse(response.body).deep_symbolize_keys
            expect(json[:name]).to eq('new organization')

            expect(json[:email]).to eq('email@gmail.com')
    
            expect(json[:welcomeText]).to eq('New welcomeText')
            
        end

        scenario 'creates a organization with invalid params'do 
          post organizations_path,
              params: 
                  {
                  
                  welcomeText:'Ne',
                  email: 'ema'
                  },
                  headers:{ authorization: "Bearer #{token}"}
          expect(response).to have_http_status(422)
          json = JSON.parse(response.body)
          expect(json[0]).to eq("Name can't be blank")
          expect(json[1]).to eq("Name is too short (minimum is 6 characters)")
          expect(json[2]).to eq("Email is invalid")
          expect(json[3]).to eq("Welcometext is too short (minimum is 6 characters)")

        end


        scenario 'create a organization with blank name' do
          post organizations_path, params: { name: "", email: "new@gmail.com", welcomeText: "para probar creacion"},
    
          headers:{ authorization: "Bearer #{token}"}
          expect(response.status).to eq(422)
          json = JSON.parse(response.body)
          expect(json[0]).to eq("Name can't be blank")
          expect(json[1]).to eq("Name is too short (minimum is 6 characters)")

          end
      

      scenario 'create a organization with blank email' do
        post organizations_path,params: { name: "modificado", email: " ", welcomeText: "para probar modificacion"},
      
        headers:{ authorization: "Bearer #{token}"}
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json[0]).to eq("Email can't be blank")
        expect(json[1]).to eq("Email is invalid")

        end
    

    scenario 'create a organization with blank welcomeText' do
      post organizations_path, params: { name: "nombre de creacion", email: "email@gmail.com", welcomeText: ""},
        
      headers:{ authorization: "Bearer #{token}"}
      expect(response.status).to eq(422)
      json = JSON.parse(response.body)
      expect(json[0]).to eq("Welcometext can't be blank")
      expect(json[1]).to eq("Welcometext is too short (minimum is 6 characters)")

      end
  end
end