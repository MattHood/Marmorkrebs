module VotesHelper
  def vote_button(votable, kind)
    kinds = Vote.kinds.keys.map &:to_sym
    raise "`kind` must be one of #{kinds}" unless kinds.include? kind
    raise "`votable` must be an object which includes the `Votable` concern" unless votable.class.ancestors&.include? Votable
    text = { upvote: '^', downvote: 'v' }[kind]
    classes = []
    classes << { upvote: 'upvoter', downvote: 'downvoter' }[kind]

    path = nil
    method = nil
    if user_signed_in?
      existing_vote = votable.votes.find_by kind:, voter: current_user
      if existing_vote
        method = :delete
        path = votable_vote_path votable, existing_vote
        classes << 'selected'
      else
        method = :post
        path = votable_votes_path votable, kind:
      end
    else
      method = :get
      path = new_user_session_path
      unless kind == :upvote
        classes << 'hidden'
      end
    end
    button_to text, path, method:, class: classes
  end

  def votable_votes_path(votable, *args)
    case votable
    when Post
      post_votes_path votable, *args
    when Comment
      comment_votes_path votable, *args
    end
  end

  def votable_vote_path(votable, vote, *args)
    case votable
    when Post
      post_vote_path votable, vote, *args
    when Comment
      comment_vote_path votable, vote, *args
    end
  end

  
end
