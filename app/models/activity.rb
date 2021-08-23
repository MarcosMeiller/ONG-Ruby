class Activity < ApplicationRecord
  validates :name, presence: true, length: { minimum: 6, maximum: 30 }
  validates :content, presence: true, length: { minimum: 6, maximum: 100 }
  validates :image, presence: true
end
