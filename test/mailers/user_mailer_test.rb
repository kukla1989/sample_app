require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:roma)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["romankyk@gmail.com"], mail.from
    assert_match user.name, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
  end

  test "reset password" do
    user = users(:roma)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal mail.subject, "Reset you password"
    assert_equal ["romankyk@gmail.com"], mail.from
    assert_equal [user.email], mail.to
    assert_match CGI.escape(user.email), mail.body.encoded
    assert_match CGI.escape(user.reset_token), mail.body.encoded
  end
end
