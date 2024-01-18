require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = create(:user, email: Faker::Internet.email, password: Faker::Internet.password)
  end
    
  test "user can login from root" do
    visit root_url
    assert_selector "a[href=\"#{new_user_session_path}\"]"
    # visit new_user_session_path
    # assert_selector "form[action=\"#{new_user_session_path}\"][method=\"post\" i]" do |form|
    #   form.fill_in 'user[email]', with: @user.email
    #   form.fill_in 'user[password]', with: @user.password
    #   form.click_button 'commit'
    #   assert_current_path root_path
    # end
  end
end
