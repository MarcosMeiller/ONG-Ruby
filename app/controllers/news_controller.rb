class NewsController < ApplicationController
  before_action :set_novelty, only: %i[show update destroy]

  def index
    render json: {
      news: params[:page].present? ? one_page_hash : full_news_hash,
      status: 200
    }
  end

  def show
    render json: @novelty, status: :ok
  end

  def create
    novelty = New.new(news_params)
    novelty.type_news = 'news'

    if novelty.save
      render json: novelty, status: :created
    else
      render json: novelty.errors, status: :unprocessable_entity
    end
  end

  def update
    if @novelty.update(news_params)
      render json: @novelty
    else
      render json: @novelty.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @novelty.update({ is_deleted: true })
    render json: @novelty
  end

  def comments
    novelty = New.find(params[:news_id])
    comments = novelty.comments
                      .where(is_deleted: false)
                      .select(:id, :body)
                      .order(:created_at)

    render json: comments, status: :ok
  end

  private

  def news_params
    params.require(:new).permit(:name, :content, :image, :category_id)
  end

  def set_novelty
    @novelty = New.find(params[:id])
  end

  def number_of_pages
    (New.count / New.per_page) + 1
  end

  def one_page_hash
    hostname = request.host
    {
      previous_page: params[:page].to_i.zero? ? nil : "#{hostname}/news/query?page=#{params[:page].to_i - 1}",
      news: New.paginate(page: params[:page].to_i),
      next_page: params[:page].to_i == number_of_pages ? nil : "#{hostname}/news/query?page=#{params[:page].to_i + 1}"
    }
  end

  def full_news_hash
    hash = {}
    i = 0
    number_of_pages.times do
      hash["page#{i + 1}"] = {
        previous_page: i.zero? ? nil : "page#{i}",
        news: New.paginate(page: i + 1),
        next_page: i == number_of_pages ? nil : "page#{i + 2}"
      }
      i += 1
    end
    hash
  end
end
