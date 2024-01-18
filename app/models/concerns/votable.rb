module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable

    def vote_score = votes.upvote.count - votes.downvote.count

    def create_upvote!(voter)
      votes.downvote.where(voter:).delete_all
      votes.upvote.create! voter: voter
    end

    def create_downvote!(voter)
      votes.upvote.where(voter:).delete_all
      votes.downvote.create! voter: voter
    end
  end
end
