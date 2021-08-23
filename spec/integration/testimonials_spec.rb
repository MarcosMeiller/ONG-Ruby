require 'swagger_helper'

RSpec.describe 'api/testimonials', type: :request do
  # 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.UlJWqVUPnEqxjgXAJLPwIg3E0PcAjaCCTe4daSjT8HM'

  ############################################################################################################################################
  path '/testimonials' do
    get 'List Testimonial' do
      tags 'Testimonials'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string

      response 200, 'successful' do
        run_test!
      end
    end

    post 'Creates a testimonial' do
      tags 'Testimonials'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :testimonial, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          content: { type: :string }
        }
      }

      response '200', 'testimonial created' do
        let(:testimonial) { { name: 'testimonial', content: 'content testimonial' } }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:testimonial) { { name: 'testimonial', content: 'content testimonial' } }
        run_test!
      end

      response '400', 'bad request' do
        let(:testimonial) { { name: 'testimonial', content: 'content testimonial' } }
        run_test!
      end
    end
  end

  ############################################################################################################################################
  
  path '/testimonials/{id}' do
    put 'Update testimonial' do
      tags 'Testimonials'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string
      parameter name: :testimonial, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          content: { type: :string }
        }
      }

      response '200', 'testimonial updated' do
        let(:testimonial) { { name: 'testimonial', content: 'content testimonial' } }
        run_test!
      end

      response '404', 'category not found' do
        let(:id) { 'testimonial no encontrado' }
        run_test!
      end
    end

    delete 'Delete testimonial' do
      tags 'Testimonials'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string

      response '200', 'testimonial deleted' do
        let(:id) { '1' }
        run_test!
      end

      response '404', 'testimonial not found' do
        let(:id) { 'testimonial no encontrado' }
        run_test!
      end
    end
  end
end
