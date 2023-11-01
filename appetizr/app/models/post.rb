class Post < ApplicationRecord

  has_one_attached :image

  
  belongs_to :category, class_name: 'Category', optional: true
  belongs_to :user, class_name: 'User', optional: true 
  has_many :reactions, as: :reactionable
  has_many :responses, as: :respondable
  # ...
end
