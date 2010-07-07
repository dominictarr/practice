
class InvalidLogin < Exception; end

class UserRegistry
	
	def initialize 
		@users = []
		@logins = Hash.new
	end
	def new_user(name,pw1,pw2)
		n = user(name)
		raise InvalidLogin.new "user #{name} already exists" if n

		@users << u = User.new
		u.name = name
		u.registry = self
		u.set_password pw1
		u.confirm_password pw2
		
		u
	end
	def user(name)
		@users.find {|f| f.name == name}
	end
	def login (session_id, user_name,password)
		u = user(user_name)
		raise InvalidLogin.new "user \"#{user_name}\" does not exist" if u.nil? 

		if  u.password_matches(password) then
			@logins[session_id] = u
		else
			raise InvalidLogin.new "incorrect username or password"
		end
	end
	def loggedin? (session_id)
		@logins[session_id]
	end
	def logout (session_id)
		@logins
		@logins.delete session_id
	end
end
class User
	attr_accessor :registry, :name
	def set_password(pw)
	  #if @password
		if pw.nil? or pw == "" then
		  raise InvalidLogin.new "\"#{pw}\" is not a valid password"
		end
		@password_to_confirm = pw
	end

	def password_matches (pw)
	  return @password == pw
	end

	def confirm_password(pw)
		if pw == @password_to_confirm then
	  	  @password = @password_to_confirm
		end
		true
	end
end
