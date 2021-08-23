class AuthenticationController < ApplicationController
  before_action :authorized, except: [:login]
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = encode_token(user_id: @user.id)
      render json: { user: @user, token: token }
    else
      render json: { ok: false }, status: :unauthorized
    end
  end
end
