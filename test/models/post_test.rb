require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "post can be upvoted and downvoted by different users" do
    post = create :post

    assert_equal 0, post.vote_score
    prev = 0
    [1, 2, 1, 0, -1, -2, -1, 0, 2, -2].each do |goal|
      (goal - prev).abs.times do
        voter = create :user 
        goal < prev ? (post.create_downvote! voter) : (post.create_upvote! voter)
      end
      assert_equal goal, post.vote_score
      prev = goal
    end
  end

  test "post can be alternatively upvoted and downvoted by the same user" do
    post = create :post
    voter = create :user
    post.create_upvote! voter
    assert_equal 1, post.vote_score
    post.create_downvote! voter
    assert_equal -1, post.vote_score
  end

  test "post cannot have multiple upvotes or downvotes from the same user" do
    post = create :post
    voter = create :user
    
    post.create_upvote! voter
    assert_equal 1, post.vote_score
    assert_raises ActiveRecord::RecordInvalid do
      post.create_upvote! voter
    end

    post.create_downvote! voter
    assert_equal -1, post.vote_score
    assert_raises ActiveRecord::RecordInvalid do
      post.create_downvote! voter
    end
  end
end
