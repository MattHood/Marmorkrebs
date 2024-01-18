class VotesController < ApplicationController
  before_action :set_votable
  # TODO Set up some access controls!

  def create
    case params[:kind]
    when 'upvote'
      @votable.create_upvote! current_user
    when 'downvote'
      @votable.create_downvote! current_user
    else
      raise ActionController::BadRequest.exception
    end
    render @votable
  end

  def destroy
    @votable.votes.delete_by id: params[:id], voter: current_user
    render @votable
  end

  private
  def set_votable
    if params[:post_id]
      @votable = Post.find params[:post_id]
    elsif params[:comment_id]
      @votable = Comment.find params[:comment_id]
    else
      raise ActionController::ParameterMissing.new 'Missing votable id'
    end

    unless @votable
      raise ActiveRecord::RecordNotFound
    end
  end
end
