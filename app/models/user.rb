class User < ApplicationRecord
  belongs_to :role
  has_many :contacts, dependent: :destroy
  has_many :comments
  has_secure_password
  validates :firstName, presence: true
  validates :lastName, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: /[^@\s]+@[^@\s]+\z/ }
  validates :password, presence: true

  # Admin function. Id: 1 (Admin)
  def admin?
    role_id == 1
  end
end
