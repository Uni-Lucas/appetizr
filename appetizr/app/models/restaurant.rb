class Restaurant < ApplicationRecord
  
  belongs_to :category, class_name: 'Category', optional: true
  has_many :ranks, class_name: 'Rank', foreign_key: 'what'
  has_many :reviews, as: :reviewable
  has_many :dishes
  has_and_belongs_to_many :users
  # ...
end
