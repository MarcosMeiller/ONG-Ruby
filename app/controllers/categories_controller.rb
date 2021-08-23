class CategoriesController < ApplicationController
  before_action :set_category, only: [:update, :destroy]
  before_action :admin_authorized

  def index
    render json: {
      categories: @categories = categories.select(:id, :name).paginate(page: params[:page], per_page: 10),
      nextPage: if !@categories.next_page.nil?
                 "#{request.host}/categories?page=#{@categories.next_page}"
                else
                  "it is last page, limit pages:#{@categories.total_pages} "
                end,
      previousPage: if !@categories.previous_page.nil?
                      "#{request.host}/categories?page=#{@categories.previous_page}"
                    else
                      "it is first page"
                    end,
      totalPages: @categories.total_pages,
      status: 200
    }
  end

  def show
    @category = categories.find_by(id: params[:id])
    render json: {
      message: show_response[:message]
    }, status: show_response[:status]
  end

  def create
    @category = Category.new(category_params)
    if @category.valid?
      @category.save!
      message = ok_create_response
    else
      message = bad_create_response
    end
    render json: message, status: message[:status]
  end

  def destroy
    response = destroy_response
    render json: {
      message: response[:message]
    }, status: response[:status]
  end

  def update
    if @category.nil?
      response = bad_update_response
    else
      @category.update(category_params)
      response = ok_update_response
    end
    render json: response, status: response[:status]
  end

  private

  def ok_update_response
    {
      message: 'La categoría se actualizó',
      category: @category,
      status: 200
    }
  end

  def bad_update_response
    {
      message: 'No se encontró la categoría solicitada',
      status: 404
    }
  end

  def bad_create_response
    {
      message: 'Su categoria no pudo crearse',
      errors: @category.errors.full_messages.join('-'),
      status: :bad_request
    }
  end

  def ok_create_response
    {
      message: 'Su categoria fue creada',
      category: @category,
      status: 200
    }
  end

  def no_category
    @category.nil? || @category.is_deleted
  end

  def destroy_response
    if no_category
      { message: 'La categoría no se encontró o ya fue eliminada', status: 404 }
    else
      @category.update_attribute(:is_deleted, true)
      { message: 'La categoría ha sido eliminado correctamente', status: :ok }
    end
  end

  def show_response
    if @category.nil?
      { message: 'No se encontró la categoría solicitada', status: 404 }
    else
      { message: @category, status: 200 }
    end
  end

  def categories
    Category.where(is_deleted: false)
  end

  def set_category
    @category = Category.find_by(id: params[:id])
  end

  def category_params
    params.permit(:id, :name, :description)
  end

  def admin?
    @user.admin?
  end

  def no_admin_message
    {
      message: 'Usted no es administrador y no puede ejecutar esta acción'
    }
  end

  def admin_authorized
    render json: no_admin_message, status: :unauthorized unless admin?
  end
end
