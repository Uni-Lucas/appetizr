class Restaurant < ApplicationRecord
  
  belongs_to :category
  has_many :ranks
  has_many :reviews, as: :reviewable
  has_many :dishes
  has_and_belongs_to_many :users
  # ...
end
