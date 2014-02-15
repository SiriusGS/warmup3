require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
    SUCCESS = 1
    ERR_BAD_CREDENTIALS = -1
    ERR_USER_EXISTS = -2
    ERR_BAD_USERNAME = -3
    ERR_BAD_PASSWORD = -4

    test "reset: Delete All Users" do
        code = User.add("u1","p1")
        assert code == SUCCESS, "Adding user failed"
        User.TESTAPI_resetFixture
        assert User.all == [], "Delete failed"
    end

    test "add Duplicate User with same password" do
        User.TESTAPI_resetFixture
        code = User.add("u","p")
        assert code == SUCCESS, "Adding user failed"
        code = User.add("u", "p")
        assert code == ERR_USER_EXISTS, "Adding exist user"
    end

    test "add Duplicate user with diff password" do
        User.TESTAPI_resetFixture
        code = User.add("u","p")
        assert code == SUCCESS, "Adding user failed"
        code = User.add("u", "pp")
        assert code == ERR_USER_EXISTS, "Adding exist user"
    end

    test "add Blank Username" do
        User.TESTAPI_resetFixture
        code = User.add("", "p")
        assert code == ERR_BAD_USERNAME, "Adding user with blank username"
    end

    test "add too long Username" do
        User.TESTAPI_resetFixture
        code = User.add("u"*129, "p2")
        assert code == ERR_BAD_USERNAME, "Adding user with too long username"
    end

    test "add too long Password1" do
        User.TESTAPI_resetFixture
        code = User.add("my", "p"*129)
        assert code == ERR_BAD_PASSWORD, "Adding user with bad password"
    end

    test "add too long Password" do
        User.TESTAPI_resetFixture
        code = User.add("james", "l"*129)
        assert code == ERR_BAD_PASSWORD, "Adding user with bad password"
    end

    test "login Count" do
        User.TESTAPI_resetFixture
        code = User.add("justin","bb")
        assert code == SUCCESS, "Wrong count"
        code = User.login("justin","bb")
        assert code == 2, "Wrong count"
        code = User.login("justin","bb")
        assert code == 3, "Wrong count"
    end

    test "login User not Exists" do
        User.TESTAPI_resetFixture
        code = User.login("hi","buddy")
        assert code == ERR_BAD_CREDENTIALS, "Login user not exist"
    end

    test "login failed" do
        User.TESTAPI_resetFixture
        code = User.add("hello","world")
        assert code == SUCCESS, "Adding user failed"
        code = User.login("hello","all")
        assert code == ERR_BAD_CREDENTIALS, "Login failed"
    end
end