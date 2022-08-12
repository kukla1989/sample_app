require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @not_activated_user = users(:not_activated)
    @user = users(:roma)
  end

  test "should redirect from show if user not activated" do
    get user_path(@not_activated_user)
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should show user if account activated" do
    get user_path(@user)
    assert_template 'users/show'
  end
end
