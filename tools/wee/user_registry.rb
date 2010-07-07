
class UserRegistryWee < Wee::Component

#allow signin/logon
#username,
#password
#register, login buttons

#on 'register', show confirm password field, and email address.

#the user registry should be some sort of singleton type object.

def render(r)
	r.form {
		r.text_field.callback {|u|@username = u}
		r.password_field.callback {|u|@password = u}
		r.submit_button.with("login")
	}
end
end
