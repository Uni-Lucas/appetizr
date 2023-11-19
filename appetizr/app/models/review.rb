class Review < ApplicationRecord
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :reviewable, polymorphic: true
  has_many :responses, as: :respondable
  has_many :reactions, as: :reactionable

  before_destroy do |ts|
    responses.destroy
    reactions.delete
  end
end
