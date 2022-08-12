require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup

  test "invalid sign up information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name:   'asdf',
                                       email: 'S@gam.com',
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
      post users_path, params: {user: {name:   'oleg',
                                       email: 'roma@gj.com',
                                       password:              'asddfdasfdaf',
                                       password_confirmation: 'asddfdasfdaf'} }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup

  def setup
    super
    post users_path, params: {user: {name: 'example', email: 'ex@ds.com',
                                     password: 'password',
                                     password_confirmation: 'password'}}
    @user = assigns(:user)
  end

  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able login without activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able activate with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not @user.activated?
  end

  test "should not be able activate with invalid email " do
    get edit_account_activation_path(@user.activation_token, email: "wrong@email.com")
    assert_not @user.activated?
  end

  test "should log in successfully after click on activation link" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select "div.alert-success"
    assert is_logged_in?
  end





end
