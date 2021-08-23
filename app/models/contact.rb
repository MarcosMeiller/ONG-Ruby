class Contact < ApplicationRecord
    belongs_to :user
    validates :name, presence: true, length: { minimum: 3, maximum: 30 }
    validates :email, presence: true, format: { with: /[^@\s]+@[^@\s]+\z/ }
end
