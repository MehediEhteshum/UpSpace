require 'test_helper'

class SpaceTest < ActiveSupport::TestCase

  test "should not create space without title" do
    space = Space.new
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.price = 100
    space.description = "Description"
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without title."
  end

  test "should not create space without listing type" do
    space = Space.new
    space.title = "Title"
    space.listing_category = "Art Gallery"
    space.price = 100
    space.description = "Description"
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without listing_type."
  end

  test "should not create space without price" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without price."
  end

  test "should not create space without description" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.price = 100
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without description."
  end

  test "should not create space without capacity" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.price = 100
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without capacity."
  end

  test "should not create space without address" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.price = 100
    space.capacity = 10
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without address."
  end

  test "should not create space without parking" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.price = 100
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without parking."
  end

  test "should not create space without latitude" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.price = 100
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.longitude = -75.6933067
    space.instant = 0
    assert_not space.save, "Created space without latitude."
  end

  test "should not create space without longitude" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.price = 100
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.instant = 0
    assert_not space.save, "Created space without longitude."
  end

  test "should not create space without instant" do
    space = Space.new
    space.title = "Title"
    space.listing_type = "Daily"
    space.listing_category = "Art Gallery"
    space.description = "Description"
    space.price = 100
    space.capacity = 10
    space.address = "100 Road Street, City, PR"
    space.parking = "Free"
    space.latitude = 45.4203434
    space.longitude = -75.6933067
    assert_not space.save, "Created space without instant."
  end

end
