require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "flash after wrong login not appear on next page" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: 'sfda@sf', password: 'sadfasdfsadf'} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
