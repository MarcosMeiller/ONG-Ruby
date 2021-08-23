class Member < ApplicationRecord
    has_one_attached :memberImage
    validates :name, presence: true
    self.per_page = 10
end
