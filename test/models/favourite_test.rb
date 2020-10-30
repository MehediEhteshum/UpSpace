require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase

  test "should not create favourite without space" do
    favourite = Favourite.new
    favourite.user_id = 1
    assert_not favourite.save, "Created favouite without space."
  end

  test "should not create favourite without user" do
    favourite = Favourite.new
    favourite.space_id = 1
    assert_not favourite.save, "Created favouite without user."
  end

end
