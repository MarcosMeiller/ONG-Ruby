class Testimonial < ApplicationRecord
  #configura una asignaciòn uno a uno entre registros y archivos
  validates :name, presence: true, length: { minimum: 6, maximum: 30 }
  validates :content, presence: true, length: { minimum: 10, maximum: 100 }
  validates :image, presence: false
  validates :is_deleted, inclusion: { in: [true, false] }
  self.per_page = 10
end
