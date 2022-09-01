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

  test "should not be allowed throughout the web edit admit attribute" do
    log_in_as @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {user: {name: @other_user.name,
                                                       email: @other_user.email,
                                                       admin: true}}
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not log in" do
    assert_no_difference 'User.count' do
      delete user_path(@other_user)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy if user not admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect following if not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_path
  end

  test "should redirect followers if not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_path
  end
end
