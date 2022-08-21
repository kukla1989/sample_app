require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:roma)
    @micropost = @user.microposts.build(content: "some content")
  end

  test "should be valid" do
    @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be presence" do
    @micropost.content = "     "
    assert_not = @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "most recent micropost should be first in list" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
