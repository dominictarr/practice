require 'rubygems'
require 'wee'
require 'tools/user_registry'
require 'tools/wee/handler'

class UserRegistryWee < Wee::Component

#allow signin/logon
#username,
#password
#register, login buttons

#on 'register', show confirm password field, and email address.

#the user registry should be some sort of singleton type object.

include HandlerMixin
def handles_class; UserRegistry; end
def handle (obj) @tool_state = obj; end

def handle (obj)
	@registry = obj
end

def render(r)
	if @signup then
		r.form {
   	   	  r.label "#{@message}<br>" if @message
		  r.label "user name"
		  r.text_input.callback {|u| @username = u}
		  r.break
		  r.label "password"
		  r.password_input.callback {|u| @password = u}
		  r.break
		  r.label "confirm password"
		  r.password_input.callback {|u| @password2 = u}
		  r.break
		  r.submit_button.value("Signup").callback {
		  begin
			u = @registry.new_user(@username,@password,@password2)
   		    	@signup = false
  		    	@message = "created new user: #{u.name}"
		  rescue InvalidLogin => e
			@message = e.message
		  end
		  }
		  r.submit_button.value("Cancel").callback {
   		    @signup = false
  		    @message = nil
		  }
 		  r.anchor.callback {@signup = false}.with("cancel")
		}
	elsif u = @registry.loggedin?(session.id) then
	  r.label("signed in as <b><i>#{u.name}</i></b> ")
	  r.anchor.callback{ 
		@registry.logout(session.id)
	  }.with("logout")
	else
	  r.form {
	    r.label "#{@message}<br>" if @message
    	    r.label "User name"
	    r.text_input.callback {|u|@username = u}
	    r.break
	    r.label "Password"
	    r.password_input.callback  {|u|@password = u}
	    r.break
	    r.space
	    r.submit_button.value("Login").callback {
		begin
		  @registry.login(r.session.id,@username,@password)
		rescue InvalidLogin => e
		  @message = e.message
		end
	    }
	    r.submit_button.value("Signup").callback {
 	      @signup = true
  	      @message = nil
	    }
	  }
	end
end

end

Wee.runcc(UserRegistryWee, :server => :Mongrel) if __FILE__ == $0

