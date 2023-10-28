class Category < ApplicationRecord
  self.primary_key = "nombre"
  has_many :restaurants
  has_many :posts, class_name: 'Post', foreign_key: 'categoria'
  validates :nombre, presence: true
end
