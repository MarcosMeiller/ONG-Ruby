# frozen_string_literal: false

class Organization < ApplicationRecord
  has_one_attached :picture, dependent: :destroy
  has_many :slides, -> { order(order: :desc) }, dependent: :destroy

  validates :name, presence: true, length: { minimum: 6, maximum: 30 }
  validates :email, presence: true, format: { with: /[^@\s]+@[^@\s]+\z/ }
  validates :welcomeText, presence: true, length: { minimum: 6, maximum: 100 }
end
