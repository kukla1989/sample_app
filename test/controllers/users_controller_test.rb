require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:roma)
    @other_user = users(:inna)
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @user
    get edit_user_path @other_user
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @user
    patch user_path(@other_user), params: {user: {name: 'anton',
                                                  email: @other_user.email}}
    assert_redirected_to root_path
  end


  test "should redirect edit when not logged in" do
    get edit_user_path @user
    assert_redirected_to login_path
    follow_redirect!
    assert_template 'sessions/new'
    assert_not flash.empty?
  end


  test "should redirect update when not logged in" do
    patch user_path(@user), params: {user: {name: 'sdf', email: 'sf@df.com'}}
    assert_redirected_to login_path
    assert_not flash.empty?
  end


  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect from index to not logged in user" do
    get users_path
    assert_redirected_to login_path
  end
end
