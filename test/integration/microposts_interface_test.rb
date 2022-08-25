require "test_helper"

class MicropostsInterface < ActionDispatch::IntegrationTest
  def setup
    @user = users(:inna)
    log_in_as @user
  end
end

class MicropostInterfaceTest < MicropostsInterface

  test "should paginate microposts if count more then 30" do
    get root_path
    assert_select "div.pagination"
    assert_select "a[href=?]", '/?page=2'
  end

  test "should create error but not create micropost with invalid submission" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: ""}}
    end
    assert_select "div#error_explanation"
  end

  test "should create micropost" do
    content = "some new content for micropost"
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end

  test "should not have delete link on other micropost" do
    get users_path(users(:roma))
    assert_select 'a', { text: "delete", count: 0}
  end

  test "should have delete links on own micropost" do
    get user_path(@user)
    assert_select 'a', text: "delete"
  end

  test "should be able delete own micropost" do
    assert_difference "Micropost.count", -1 do
      delete micropost_path(@user.microposts.first)
    end
  end

  test "home page should include right count of micropost of this user" do
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
  end
end

class ImageUploadTest < MicropostsInterface

  test "should have input file field for images" do
    get root_url
    assert_select "input[type=file]"
  end

  test "should be able to attach image" do
    img = fixture_file_upload("test/fixtures/sun.jpg", "image/jpeg")
    content = "unique content"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: content, image: img}}
    end
    assert assigns(:micropost).image.attached?
    follow_redirect!
    assert_match content, response.body
  end
end

