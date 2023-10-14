class Review < ApplicationRecord
  belongs_to :user
  belongs_to :reviewable, polymorphic: true
  has_many :responses, as: :respondable
  has_many :reactions, as: :reactionable
  # ...
end
