class Category < ApplicationRecord
  self.primary_key = "nombre"
  
  has_one_attached :photo
  has_many :restaurants
  has_many :posts
  validates :nombre, presence: true
end
