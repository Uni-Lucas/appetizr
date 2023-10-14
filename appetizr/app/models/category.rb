class Category < ApplicationRecord
  has_many :restaurants
  has_many :posts
end
