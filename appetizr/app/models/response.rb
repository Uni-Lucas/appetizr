class Response < ApplicationRecord
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :respondable, polymorphic: true
  has_many :reactions, as: :reactionable, dependent: :delete_all
end
