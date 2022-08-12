require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:roma)
  end
end

class InvalidInformationTest < UsersLoginTest
  def setup
    super
    #invalid password
    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }
    assert_not is_logged_in?
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
  end


  test "login path" do
    get login_path
    assert_template 'sessions/new'
  end


  test "flash disappear after go to next page(invalid information)" do
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end


class ValidLogin < UsersLoginTest
  def setup
    super
    log_in_as(@user)
  end
end

class ValidLoginTest < ValidLogin
  test "valid login" do
    assert is_logged_in?
    assert_redirected_to @user
  end

  test "login with remember" do
    assert_not cookies[:user_id].blank?
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remember" do
    log_in_as(@user, remember_me: '1')
    # log in again but without remember
    log_in_as(@user, remember_me: '0')
    assert cookies[:user_id].blank?
  end

  test "redirect after login" do
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

class LogOut < ValidLogin

  def setup
    super
    delete logout_path
  end
end

class LogOutTest < LogOut

  test "successful log out" do
    assert_not is_logged_in?
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "should still work after logout in second window" do
    delete logout_path
    assert_redirected_to root_url
  end
end

