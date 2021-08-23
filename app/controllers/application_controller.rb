# frozen_string_literal: true

require 'aws-sdk-s3'

class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      secret_key = Rails.application.secrets.secret_key_base
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(token, secret_key, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  # SERVICE UPLOAD IMAGE. CREATED By Juan Bugallo

  def init_aws
    @s3 = Aws::S3::Resource.new
  end

  # USE THIS FUNCTIION TO UPLOAD IMAGE
  # Put parammeter image in upload function

  def upload_object(image)
    raise 'Please upload image' if image.nil?

    if init_aws

      image = params[:picture]
      obj = @s3.bucket('ruby-rocket').object(image.original_filename)

      raise 'Image name has been created' if obj.exists?

      obj.put(body: image)

      #Return URL Object
      return obj.public_url

    end
  rescue StandardError => e
    render json: e
  end
  
  def rol_access 
    return render json:{
      message: "You are not authorized"
    },status: :forbidden unless @user.admin?
  end
end
