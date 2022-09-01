require "test_helper"

class Following < ActionDispatch::IntegrationTest

  def setup
    @user = users(:roma)
    @other_user = users(:inna)
    log_in_as @user
  end
end

class FollowingTest < Following

  test "following page" do
    get following_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end

class FollowTest < Following

  test "should follow user without turbo-stream" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, params: {followed_id: @other_user.id}
    end
    assert_redirected_to @other_user
  end

  test "should follow user with Hotwire" do
    assert_difference "@user.following.count", 1 do
      post relationships_path(format: :turbo_stream),
           params: {followed_id: @other_user.id}
    end
  end
end

class Unfollow < Following

  def setup
    super
    @user.follow(@other_user)
    @relationship = @user.active_relationships.find_by(followed_id: @other_user.id)
  end
end

class UnfollowTest < Unfollow

  test "should unfollow a user the standard way" do
    assert_difference "@user.following.count", -1 do
      delete relationship_path(@relationship)
    end
    assert_response :see_other
    assert_redirected_to @other_user
  end

  test "should unfollow a user with Hotwire" do
    assert_difference "@user.following.count", -1 do
      delete relationship_path(@relationship, format: :turbo_stream)
    end
  end
end
