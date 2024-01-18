require "test_helper"

class VotingTest < ActionDispatch::IntegrationTest
  include VotesHelper
  include Devise::Test::IntegrationHelpers

  setup do
    @votable = create :post
    @user = create(:user)
    sign_in @user
    
  end
  
  test "post can be upvoted" do
    assert_vote_score 0
    post votable_votes_path(@votable, kind: :upvote)
    assert_vote_score 1
  end

  test "post can be downvoted" do
    assert_vote_score 0
    post votable_votes_path(@votable, kind: :downvote)
    assert_vote_score -1
  end

  # test "invalid vote kind is a bad request" do
  #   assert_vote_score 0
  #   assert_raises ActionController::BadRequest do
  #     post votable_votes_path(@votable, kind: :asdfvote)
  #   end
  #   assert_vote_score 0
  # end

  test "vote can be removed" do
    assert_vote_score 0
    post votable_votes_path(@votable, kind: :upvote)
    assert_vote_score 1
    vote = Vote.find_by votable: @votable, voter: @user
    delete votable_vote_path(@votable, vote)
    assert_vote_score 0
  end

  private
  def assert_vote_score(score) = assert_equal(score, @votable.vote_score)
    
end
