require "test_helper"

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:roma).id,
                                     followed_id: users(:inna).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require follower" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require followed" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
