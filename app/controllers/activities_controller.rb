# frozen_string_literal: true

class ActivitiesController < ApplicationController
  before_action :authorized
  before_action :rol_access

  def create
    @activity = Activity.new(params_activity)

    if @activity.save
      render json: @activity
    else
      render json: @activity.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update(params_activity)
      render json: @activity
    else
      render json: @activity.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def params_activity
    params.require(:activity).permit(:name, :content, :image)
  end
end
