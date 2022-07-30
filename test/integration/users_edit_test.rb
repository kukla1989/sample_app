require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:roma)
    log_in_as(@user, 'password')
  end


  test "successful render edit page" do
    get edit_user_path(@user)
    assert_template 'users/edit'
  end


  test "invalid edit information" do
    patch user_path(@user), params: {user: {name: '', email: 'sdf@sdf.com',
                                            password: 'asdasdfdsaf',
                                            password_confirmation: 'asdxzvczxczxvzx'}}
    assert_template 'users/edit'
    assert_select 'div.alert-danger', "The form contains 2 errors."
  end


  test "successful edit" do
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
end
