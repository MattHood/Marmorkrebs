class PostsController < ApplicationController
  POSTS_PER_PAGE = 25
  def index
    @current_page = params[:page]&.to_i || 1
    @show_previous_page = @current_page > 1
    @starting_index = (@current_page - 1) * POSTS_PER_PAGE + 1
    @posts = Post.hot @current_page, POSTS_PER_PAGE
    @show_next_page = @current_page * POSTS_PER_PAGE < Post.count
  end

  def show
    @post = Post.find params[:id]
  end
end
