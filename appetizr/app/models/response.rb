class Response < ApplicationRecord
  belongs_to :user
  belongs_to :respondable, polymorphic: true
  has_many :reactions, as: :reactionable
end
