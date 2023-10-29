class Category < ApplicationRecord
  self.primary_key = "nombre"
  
  has_one_attached :photo
  has_many :restaurants, class_name: 'Restaurant', foreign_key: 'categoria'
  has_many :posts, class_name: 'Post', foreign_key: 'categoria'
  validates :nombre, presence: true
end
