class Category < ApplicationRecord
  self.primary_key = "nombre"
  
  has_many :restaurants, class_name: 'Restaurant', foreign_key: 'categoria', dependent: :nullify
  has_many :posts, class_name: 'Post', foreign_key: 'categoria', dependent: :destroy
  validates :nombre, presence: true
end
