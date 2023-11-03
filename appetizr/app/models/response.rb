class Response < ApplicationRecord
  has_one_attached :image
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :respondable, polymorphic: true
  has_many :reactions, as: :reactionable
end
