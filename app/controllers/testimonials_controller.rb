# frozen_string_literal: true

# CLASS TESTIMONIALS
class TestimonialsController < ApplicationController
  before_action :authorized
  before_action :rol_access

  def index
    render json: {
      testimonials: params[:page].present? ? one_page_hash : full_news_hash,
      status: 200
    }
  end

  def create
    @testimonal = Testimonial.new(params_testimonial)

    if @testimonal.save
      render json: @testimonal, status: :ok
    else
      render json: { msg: @testimonal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @testimonal = Testimonial.find_by({ id: params[:id], is_deleted: false })

    return render json: { status: false, msg: 'Testimonial not found' }, status: 404 unless @testimonal

    if @testimonal.update(params_testimonial)
      render json: {
        msg: 'Testimonial updated',
        obj: @testimonal
      }
    else
      render json: {
        msg: @testimonal.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @testimonal = Testimonial.find_by({ id: params[:id], is_deleted: false })

    return render json: { status: false, msg: 'Testimonial not found' }, status: 404 unless @testimonal

    if @testimonal.update({ is_deleted: true })
      render json: {
        msg: "Testimoniald ID: #{@testimonal.id} eliminated",
        obj: @testimonal
      }
    else
      render json: {
        msg: @testimonal.errors.full_messages
      }
    end
  end

  private

  def testimonials
    Testimonial.where(is_deleted: false)
  end

  def number_of_pages
    (Testimonial.count / Testimonial.per_page).truncate + 1
  end

  def page
    params[:page].to_i
  end

  def one_page_hash
    {
      previous_page: page.zero? ? nil : "http://#{request.host}/testimonials/query?page=#{page - 1}",
      testimonials: empty_page?(page) ? 'Página vacia' : Testimonial.paginate(page: page),
      next_page: page == number_of_pages ? nil : "http://#{request.host}/testimonials/query?page=#{page + 1}"
    }
  end

  def empty_page?(page)
    Testimonial.paginate(page: page).empty?
  end

  def full_news_hash
    hash = {}
    i = 0
    number_of_pages.times do
      hash["page#{i + 1}"] = {
        previous_page: i.zero? ? nil : "http://#{request.host}/testimonials/query?page=#{i}",
        testimonials: empty_page?(i + 1) ? 'Página vacia' : Testimonial.paginate(page: i + 1),
        next_page: i == number_of_pages ? nil : "http://#{request.host}/testimonials/query?page=#{i + 2}"
      }
      i += 1
    end
    hash
  end

  def params_testimonial
    params.require(:testimonial).permit(:name, :content, :image)
  end
end
