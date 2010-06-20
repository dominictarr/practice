class Viewer
def initialize (object)
		@object = object
end
def set_control(parent,getter,setter = "#{getter}=", result_action = nil)#,setter,result_action (for actions)
		@parent = parent
		@name = getter
	if setter and parent.object.methods.include? setter then
		@is_field = true
		@setter = setter
		@object = get
	else
		@result_action = result_action
		#result action will be called with the return value of the action.
		@is_action = true
	end
	self
end

def name 
	@name
end
def set (object)
	if is_field? then
		@object = @parent.set_field(@name,object)
	else raise "!#{self}.is_field? do not call .set(#{object})" end
end
def get
	if is_field? then
		@object = @parent.get_field(@name)
	else raise "!#{self}.is_field? do not call .get" end
end
def object
	@object
end
def get_field(name)
	@object.method(name).call
end
def set_field(name,object)
	@object.method("#{name}=").call(object)
end

def member (name)
	if @members.nil? then nil
	else @members.find{|f| f.name == name} end
end
def add_members (*members)
	unless @members then
		@members = []
	end
	@members = @members + members
end

def is_field?
	@is_field
end
	#get/set works - else they throw exception
	#otherwise, it is top level.
def has_members?
	!@members.nil? and !(@members.empty?)
end 

def members
	if has_members? then
		@members
	else
		raise "{self} does not have members"
	end
end
	#members works - else throws exception.
	#members returns a list of viewers
def openable?
	@builder.viewer(@object)
end
	#allow opening the object and editing it's members.
	#relivant for non editable fields.
def is_mutable?
	is_field? or (has_members? and members.find{|f| f.is_mutable?})
end
	#has a 'set' method
def open #return a top level version of this object.
end
def is_typed?
	!@types.nil? and !@types.empty?
end
#only allows some times.
#array of acceptable types,or Procs which define tests for whether a type is allowed. or Interface objects.
#allowing fields, and then opening it complicates the builder slightly.
attr_accessor :types,:builder

def == (other)
	unless (is_field? == other.is_field?) and
		name == other.name and
		openable? == other.openable? and
		is_mutable? == other.is_mutable? and
		has_members == other.has_members? and
		types == other.types
	then return false end
	if is_field? and get != other.get 
	then return false end
	if has_members and members != other.members
	then return false end
	if openable? and builder != other.builder
	then return false end
	true
end
def is_type(object)
	if is_typed? then
		@types.find{|t|
		#	puts "#{object} is a #{t}? == #{object.is_a? t}"
			if t.is_a? Class then
				object.is_a? t
			elsif t.is_a? Proc then
				t.call(object)
			end
		}	
	else
		true
	end
end

def is_action?
	@is_action
end
def call 
	if is_action? then
		@parent.get_field(@name)
	else
		raise "!#{self}.is_action? cannot .call"
	end
end
end
