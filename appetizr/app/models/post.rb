class Post < ApplicationRecord
  belongs_to :category, class_name: 'Category', optional: true
  belongs_to :user, class_name: 'User', optional: true 
  belongs_to :restaurant, class_name: 'Restaurant', optional: true
  has_many :reactions, as: :reactionable, dependent: :delete_all
  has_many :responses, as: :respondable, dependent: :destroy

  before_destroy do |ts|
    responses.destroy
    reactions.delete
  end
end
