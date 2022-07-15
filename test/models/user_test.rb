require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "tmp", email: "tmp@gmail.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "@user should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = '   '
    assert_not @user.valid?
  end


  test 'name should not be longer then  50 symbols' do
    @user.name = 'a' * 50
    assert_not @user.valid?
  end

  test 'email should be longer then  100symbols' do
    @user.email = 'a' * 100
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = '   '
    assert_not @user.valid?
  end

  test "email validation should accept valid email" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com FSDFLA@AF....com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test"email should be saved as lower-case" do
    mixed_case_email = "dsDf@sadF.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test"password should be present (non blank)" do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test "password should be at least 6 character" do
     @user.password = @user.password_confirmation = ' ' * 5
     assert_not @user.valid?
  end
end
