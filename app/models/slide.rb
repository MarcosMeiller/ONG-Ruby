class Slide < ApplicationRecord
  belongs_to :organization
  has_one_attached :slide_image

  validates :text, presence: true
  after_save :set_image_url

  def set_image_url
    return if imageUrl == slide_image.url

    update({ imageUrl: slide_image.url })
  end
end
