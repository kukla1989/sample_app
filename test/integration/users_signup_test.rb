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

end
