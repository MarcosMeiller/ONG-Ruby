# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized, except: [:create]
  before_action :rol_access, only: [:showUsers,:update,:destroy], except: [:profile]

  def create
    @user = User.create(user_params)
    if @user.valid?
      UserNotifierMailer.welcome_email(@user).deliver_now
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: :created
    else
      render json: { error: 'not registered' }, status: 404
    end
  end

  def showUsers
    @users = User.all
    render json: @users, status: :ok
  end

  def edit
    set_userid
    render json: @userId
  end

  # PATCH: http://localhost:3000/users/:id
  def update
    set_userid
    if @userId == @user 
      if @userId.update(user_params)
        render json: @userId, status: 200
      else
        render json: @userId.errors.full_messages, status: 422
      end
    else
    render json: @userId.errors, status: 404 
    end
  end

  def destroy
    set_userid
    return render json: { error: "User not found " }, status: 404 if @userId.nil?
    if @userId== @user && @userId.is_deleted == false
      @userId.update_attribute('is_deleted', true)
      render json: {
        message: 'Data deleted, but persistent in the database',
        object_deleted: @userId
      }, status: :ok
    else
    render json:{ error: "user already deleted or not access" }, status: 404
    end
  end
  
  # como usuario quiero obtener mis datos almacenados
  def profile
    render json: @user
  end

  private

  def user_params
    params.permit(:firstName, :lastName, :photo, :email, :password, :role_id)
  end
  def set_userid
    param_user_id = params[:id]
    @userId = User.find(param_user_id)
  end
  
end
