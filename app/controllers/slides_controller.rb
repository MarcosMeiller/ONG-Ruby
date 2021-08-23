class SlidesController < ApplicationController
  before_action :rol_access
  before_action :set_slide, only: %i[show update destroy]
  before_action :decode_slide_image, only: %i[create update]

  def index
    slides = Slide.where(is_deleted: false)
                  .select(:id, :order, :imageUrl)
    render json: slides, status: :ok
  end

  def show
    render json: @slide, status: :ok
  end

  def create
    slide = Slide.new(slide_params)
    slide.order ||= Slide.order(order: :desc).first.order + 1

    if slide.save
      render json: slide, status: :created
    else
      render json: slide.errors
    end
  end

  def update
    if @slide.update(slide_params)
      render json: @slide, status: :ok
    else
      render json: @slide.errors
    end
  end

  def destroy
    @slide.update({ is_deleted: true })
    render json: @slide, status: :ok
  end

  private

  def set_slide
    @slide = Slide.find(params[:id])
  end

  def slide_params
    params.require(:slide)
          .permit(:text, :order, :organization_id, { slide_image: %i[io filename] })
  end

  def decode_slide_image
    return unless params[:slide][:slide_image]

    params[:slide][:slide_image] = {
      io: StringIO.new(Base64.decode64(params[:slide][:slide_image])),
      filename: 'Pic.jpg'
    }
  end
end
