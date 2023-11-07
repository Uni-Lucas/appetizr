class Reaction < ApplicationRecord
  validates :who, uniqueness: {scope: [:reactionable_id, :reactionable_type]}
  belongs_to :user, class_name: 'User', optional: true 
  belongs_to :reactionable, polymorphic: true
end
