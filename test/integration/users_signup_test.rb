require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid sign up information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name:   '',
                                       email: 'invalid',
                                       password:              'asdf',
                                       password_confirmation: 'asdg'} }
    end
    assert_template 'users/new'
    assert_select "div#error_explanation"
    assert_select "div.alert"
  end

  test "valid sign up information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {name:   'roman',
                                       email: 'roma@gj.com',
                                       password:              'asddfdasfdaf',
                                       password_confirmation: 'asddfdasfdaf'} }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select "div.alert-success"
  end

end
