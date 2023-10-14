class User < ApplicationRecord
  has_many :posts
  has_many :responses
  has_many :reviews
  has_many :ranks
  has_many :reactions
  has_and_belongs_to_many :restaurants
  # ...
end
