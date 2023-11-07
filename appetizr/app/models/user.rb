class User < ApplicationRecord
  self.primary_key = "nombre"

  has_many :posts, class_name: 'Post', foreign_key: 'autor'
  has_many :responses, class_name: 'Response', foreign_key: 'autor'
  has_many :reviews, class_name: 'Review', foreign_key: 'autor'
  has_many :ranks, class_name: 'Rank', foreign_key: 'who'
  has_many :reactions, class_name: 'Reaction', foreign_key: 'who'
  has_and_belongs_to_many :restaurants
  has_secure_password
end
