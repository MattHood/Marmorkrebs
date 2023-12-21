require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  test "front page lists hot posts" do
    visit posts_url
    hot_posts = Post.hot
    hot_posts.each do |post|
      url = post.link || post_url(post)
      assert_select "a[href=\"${url}\"]"
    end
  end
end
