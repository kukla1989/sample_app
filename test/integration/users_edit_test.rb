require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:roma)
  end


  test "successful render edit page" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
  end


  test "invalid edit information" do
    log_in_as(@user)
    patch user_path(@user), params: {user: {name: '', email: 'sdf@sdf.com',
                                            password: 'asdasdfdsaf',
                                            password_confirmation: 'asdxzvczxczxvzx'}}
    assert_template 'users/edit'
    assert_select 'div.alert-danger', "The form contains 2 errors."
  end


  test "successful edit" do
    log_in_as(@user)
    new_name = 'roma2'
    patch user_path(@user), params: { user: { name:  new_name,
                                              email: "roma@gmail.com",
                                              password:              "",
                                              password_confirmation: "" } }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    @user.reload
    assert_equal new_name, @user.name
  end


  test "user go to edit than to log_in and get friendly forward to edit\
              , after next login redirect to user page" do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_redirected_to edit_user_path @user
    delete logout_path
    log_in_as @user
    assert_redirected_to user_path @user
  end
end
