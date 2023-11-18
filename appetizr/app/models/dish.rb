class Dish < ApplicationRecord
  belongs_to :restaurant
  has_many :reviews, as: :reviewable, dependent: :destroy
end
