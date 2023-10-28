class User < ApplicationRecord
  has_many :posts, class_name: 'Post', foreign_key: 'autor'
  has_many :responses
  has_many :reviews
  has_many :ranks
  has_many :reactions
  has_and_belongs_to_many :restaurants
  has_secure_password
end
