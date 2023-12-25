require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  include ActionView::Helpers::DateHelper
  include Devise::Test::IntegrationHelpers

  PAGE_SIZE = 50
  OVERFLOW = 20

  setup do
    (1..(PAGE_SIZE + OVERFLOW)).each do |n|
      params = { created_at: n.hours.ago }
      case n % 3
      when 0
        params[:link] = Faker::Internet.url
      when 1
        params[:body] = Faker::Lorem.paragraph
      when 2
        params[:link] = Faker::Internet.url
        params[:body] = Faker::Lorem.paragraph
      end
      create :post, params
    end
  end
  
  test "front page lists hot posts" do
    visit posts_url
    hot_posts = Post.hot
    hot_posts.each do |post|
      url = post.link || (post_path post)
      submitter_path = user_path post.submitter
      assert_selector "li[data-short-id=\"#{post.to_param}\"]" do |element|
        element.assert_selector "a[href=\"#{url}\"]", text: post.title
        element.assert_selector "a[href=\"#{submitter_path}\"]", text: post.submitter.username
        element.assert_text (time_ago_in_words post.created_at)
      end
    end
  end

  test "front page upvote icon is linked to sign-in when not logged in" do
    visit posts_url
    assert_selector "button.upvoter"
    all "button.upvoter" do |element|
      element.assert_ancestor "form[action=\"#{new_user_session_path}\"]"
    end
  end

  test "front page upvote icon is linked to new vote route when logged in" do
    user = create(:user)
    sign_in user
    visit posts_url
    all "button.upvoter" do |anchor|
      form = anchor.ancestor "form"
      assert_match /\/posts\/[a-zA-Z0-9]+\/votes/, form[:action]
    end
  end

  
end
