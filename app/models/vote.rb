class Vote < ApplicationRecord
  belongs_to :voter, class_name: "User"
  belongs_to :votable, polymorphic: true
  enum :kind, { upvote: 0, downvote: 1 }, validate: true
  validates :votable_id, uniqueness: { scope: [:votable_type, :voter_id, :kind] }
end
