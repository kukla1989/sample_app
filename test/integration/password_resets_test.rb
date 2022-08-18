require "test_helper"

class PasswordResets < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:roma)
  end
end

class ForgotPasswordFormTest < PasswordResets

  test "password reset path" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
  end

  test "password reset wrong email" do
    post password_resets_path, params: {password_reset: {email: 'asdf'}}
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end
end

class PasswordResetForm < PasswordResets
  def setup
    super
    post password_resets_path, params: {password_reset: {email: @user.email}}
    @reset_user = assigns(:user)
  end
end

class PasswordResetFormTest < PasswordResetForm

  test "valid email" do
    assert_not_equal @user.reset_digest, @reset_user.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "reset password with wrong email" do
    get edit_password_reset_path(@reset_user.reset_token, "adf")
    assert_redirected_to root_path
  end

  test "reset password with inactivated user" do
    @reset_user.toggle!(:activated)
    get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
    assert_redirected_to root_path
  end

  test "reset password with right email but wrong token" do
    get edit_password_reset_path("wrong_token", email: @reset_user.email)
    assert_redirected_to root_path
  end

  test "reset password with right email and token" do
    get edit_password_reset_path(@reset_user.reset_token, email: @reset_user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', @reset_user.email
  end
end

class PasswordUpdateTest < PasswordResetForm
  test "update with wrong password confirmation" do
    patch password_reset_path(@reset_user.reset_token),
          params: {email: @reset_user.email,
                   user: {password:               "sdfasdf",
                          password_confirmation:  "aaaaaaaaaaaa"}}
    assert_select 'div#error_explanation'
  end

  test "update with blank password" do
    patch password_reset_path(@reset_user.reset_token),
          params: {email: @reset_user.email,
                   user: {password: "",
                   password_confirmation: ""}}
    assert_select 'div#error_explanation'
  end

  test "update with right password" do
    patch password_reset_path(@reset_user.reset_token),
          params: {email: @reset_user.email,
                   user: {password: "kukla123",
                          password_confirmation: "kukla123"}}
    assert  is_logged_in?
    assert_not flash.empty?
    assert_redirected_to @reset_user
  end
end

class ExpiredTokenTest < PasswordResets
  def setup
    super
    post password_resets_path,
         params: {password_reset: {email: @user.email}}
    @reset_user = assigns(:user)
    @reset_user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@reset_user.reset_token),
          params: {email: @reset_user.email,
                   user: {password:              "kukla123",
                          password_confirmation: "kukla123"}}
  end

  test "should redirect to new password reset page" do
    assert_redirected_to new_password_reset_path
  end

  test "should include 'expired' on the password-reset page" do
    follow_redirect!
    assert_match /expired/i, response.body
  end
end