class CommentsController < ApplicationController
  def create
    permitted = params.require(:comment).permit(:content, :post_id)    
    comment = Comment.new permitted
    comment.author = current_user
    comment.save!
    render partial: "comments/form", locals: { is_submitted: true }
  end
end
