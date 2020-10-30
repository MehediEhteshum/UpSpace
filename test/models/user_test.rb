require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not create user without password" do
    user = User.new
    user.fullname = "Full Name"
    user.email = "fullname@email.com"
    assert_not user.save, "Created user without password."
  end

  test "should not create user without name" do
    user = User.new
    user.encrypted_password = "$2a$11$YhmBdcE1tZpt0W34BgJAEe2B5/sHpgvp8f.JyvgKq0f6T0iJjwZBO"
    user.email = "fullname@email.com"
    assert_not user.save, "Created user without name."
  end

  test "should not create user without email" do
    user = User.new
    user.encrypted_password = "$2a$11$YhmBdcE1tZpt0W34BgJAEe2B5/sHpgvp8f.JyvgKq0f6T0iJjwZBO"
    user.fullname = "Full Name"
    assert_not user.save, "Created user without email."
  end

  test "should not allow normal user to be admin" do
    user = User.new
    user.fullname = "Full Name"
    user.email = "fullname@email.com"
    user.encrypted_password = "$2a$11$YhmBdcE1tZpt0W34BgJAEe2B5/sHpgvp8f.JyvgKq0f6T0iJjwZBO"
    user.save
    assert_not user.admin?, "Normal user qualified as admin."
  end

end
