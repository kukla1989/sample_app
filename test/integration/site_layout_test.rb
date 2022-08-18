require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    super
    @user = users(:roma)
  end
  test "layout_links" do
    get root_path
    assert_template 'static_page/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    log_in_as(@user)
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", user_path(@user)
    assert_select "header.navbar"
  end


  test "signup" do
    get signup_path
    assert_select "title", "Sign up | Sample App"
  end
end
