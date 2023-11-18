class Restaurant < ApplicationRecord
  belongs_to :category, class_name: 'Category', optional: true
  has_many :ranks, class_name: 'Rank', foreign_key: 'what', dependent: :destroy
  has_many :posts, class_name: 'Post', foreign_key: 'restaurant_id', dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :dishes, dependent: :destroy
  has_and_belongs_to_many :users
  # ...
end
