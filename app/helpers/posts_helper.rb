module PostsHelper
  def post_target(post) = post.link || post_path(post)
end
