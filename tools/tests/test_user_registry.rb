require 'rubygems'
require 'test/unit'
require 'tools/user_registry'


class TestUserRegistry < Test::Unit::TestCase
include Test::Unit

#create new user.
#exception if same name
  def test_simple
	ur = UserRegistry.new
	
	u = ur.new_user "ben"
	assert_equal u, ur.user("ben")
	begin
	  ur.new_user "ben"
	  fail "called new_user with a current user name."
	rescue; end
  end
  def test_register
	ur = UserRegistry.new
	
	begin
  	  u.set_password("hello")
	  u.confirm_password("hello2")
	  fail "expect expection if passwords do not match"
	rescue;	end

#	  u = ur.new_user "ben"
 # 	  u.set_password("hello")
#	  u.confirm_password("hello")

	begin
	  u = ur.new_user "ben"
  	  u.set_password("")
	  fail "expect expection if empty"
	rescue;	end

	begin
	  u = ur.new_user "ben"
  	  u.set_password(nil)
	  fail "expect expection if password is nil"
	rescue;	end
	begin
	  u = ur.new_user "ben"
	  ur.login("ben","hello")
	  fail("user not signed up properly - should throw expection")
	rescue; end

	  u.set_password "hello"
	  u.confirm_password "hello"
	  ur.login(0,"ben","hello")

	  assert ur.loggedin? 0

	  ur.logout(0)

	  assert !ur.loggedin?(0)
  end

end
