
class UserRegistry
	
	def initialize 
		@users = []
	end
	def new_user(name)
		n = user_for_name(name)
		raise "user #{name} already exists" if n

		@users << u = User.new(name)
		u.registry = self
		u
	end
	def user[](name)
		@users.find {|f| f.name == name}
	end
	def login (session_id, user_name,password)
		
		if password == user.password then
			@logins[session_id] = user
		else
			raise "incorrect username or password"
	end
	def logout (session_id)
		@logins.delete session_id
	end
end
class User
	attr_accessor :registry, :name, :password
end
