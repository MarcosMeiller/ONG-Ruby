class New < ApplicationRecord
  belongs_to :category
  has_many :comments
  validates_presence_of :name, :content, :image, :category_id
  self.per_page = 10
end
