class CommentsController < ApplicationController
  before_action :rol_access, only: :index
  before_action :set_comment, only: %i[update destroy]
  before_action :user_access, only: %i[update destroy]

  def index
    comments = Comment.where(is_deleted: false)
                      .order(:created_at)
                      .select(:id, :body)
    render json: comments, status: :ok
  end

  def create
    comment = @user.comments.build(comments_params)
    if comment.save
      render json: comment, status: :created
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comments_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors
    end
  end

  def destroy
    @comment.update({ is_deleted: true })
    render json: @comment
  end

  private

  def comments_params
    params.require(:comment).permit(:new_id, :body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def user_access
    user_authorized = @comment.user_id == @user.id || @user.admin?
    render json: { error: 'Not authorized' }, status: :unauthorized unless user_authorized
  end
end
