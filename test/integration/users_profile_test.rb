require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    get user_path(users(:roma).id)
    @user = assigns(:user)
    @microposts = assigns(:microposts)
  end

  test "profile display" do
    assert_template 'users/show'
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
  end

  test "should include count of microposts" do
    assert_select "h3", text: "Microposts (#{@microposts.count})"
  end

  test "should include paginate(count more then 30)" do
    assert_select "div.pagination", count: 1
  end

  test "should include microposts" do
    @microposts.each do |post|
      assert_select "li#micropost-#{post.id}"
      assert_match post.content, response.body
    end
  end
end
