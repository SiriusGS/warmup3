require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    SUCCESS               =   1
    ERR_BAD_CREDENTIALS   =  -1
    ERR_USER_EXISTS       =  -2
    ERR_BAD_USERNAME      =  -3
    ERR_BAD_PASSWORD      =  -4

    test "reset: Delete All Users" do
        code = User.add("u1","p1")
        assert code == SUCCESS, "Adding user failed"
        User.TESTAPI_resetFixture
        assert User.all == [], "Delete failed"
    end

    test "add: User Exists1" do
        User.TESTAPI_resetFixture
        code = User.add("u1","p1")
        assert code == SUCCESS, "Adding user failed"
        code = User.add("u1", "p1")
        assert code == ERR_USER_EXISTS, "Adding exist user"
    end

    test "add: User Exists2" do
        User.TESTAPI_resetFixture
        code = User.add("u1","p1")
        assert code == SUCCESS, "Adding user failed"
        code = User.add("u1", "p2")
        assert code == ERR_USER_EXISTS, "Adding exist user"
    end

    test "add: Bad Username1" do
        User.TESTAPI_resetFixture
        code = User.add("", "p2")
        assert code == ERR_BAD_USERNAME, "Adding user with bad username"
    end

    test "add: Bad Username2" do
        User.TESTAPI_resetFixture
        code = User.add("u"*129, "p2")
        assert code == ERR_BAD_USERNAME, "Adding user with bad username"
    end

    test "add: Bad Password1" do
        User.TESTAPI_resetFixture
        code = User.add("u1", "12"*200)
        assert code == ERR_BAD_PASSWORD, "Adding user with bad password"
    end

    test "add: Bad Password2" do
        User.TESTAPI_resetFixture
        code = User.add("u1", "p"*129)
        assert code == ERR_BAD_PASSWORD, "Adding user with bad password"
    end

    test "login: Count Test" do
        User.TESTAPI_resetFixture
        code = User.add("u1","p1")
        assert code == SUCCESS, "Wrong count"
        code = User.login("u1","p1")
        assert code == 2, "Wrong count"
        code = User.login("u1","p1")
        assert code == 3, "Wrong count"
    end

    test "login: User not Exists" do
        User.TESTAPI_resetFixture
        code = User.login("u1","p1")
        assert code == ERR_BAD_CREDENTIALS, "Login user that doesn't exist"
    end

    test "login: Wrong Password" do
        User.TESTAPI_resetFixture
        code = User.add("u1","p1")
        assert code == SUCCESS, "Adding user failed"
        code = User.login("u1","p2")
        assert code == ERR_BAD_CREDENTIALS, "Login user with wrong password"
    end
end