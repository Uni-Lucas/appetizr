class Rank < ApplicationRecord
  belongs_to :user, class_name: 'User', optional: true
  belongs_to :restaurant, class_name: 'Restaurant', optional: true
end
