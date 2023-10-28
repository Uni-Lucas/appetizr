class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :reactions, as: :reactionable
  has_many :responses, as: :respondable
  # ...
end
