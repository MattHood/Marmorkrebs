class PostsController < ApplicationController
  def index
    @posts = Post.hot
  end
end
