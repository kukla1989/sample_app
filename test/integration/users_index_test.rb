require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:roma)
    @user_inna = users(:inna)
    log_in_as(@admin)
    get users_path
  end

  test "index including pagination" do
    assert_template 'users/index'
    assert_select "div.pagination"
    assert_select "ul.users"
    User.where(activated: true).paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name
    end
  end

  test "admin can delete user" do
    assert_difference 'User.count', -1 do
      delete user_path(@user_inna)
      assert_redirected_to users_path
    end
  end

  test "dont show not activated users" do
    User.paginate(page: 1).second.toggle!(:activated)
    users = assigns(:users)
    users.each do |user|
      assert user.activated?
    end
  end
end
