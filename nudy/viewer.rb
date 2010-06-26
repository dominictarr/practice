class Viewer
attr_accessor :parent
def initialize (object)
		@object = object
end
def set_control(parent,getter,setter = "#{getter}=", result_action = nil)#,setter,result_action (for actions)
		@parent = parent
		@name = getter
	if getter.is_a? Numeric or (setter and parent.object.methods.include? setter) then 
		#if this is a field of an array, then it doesn't need a setter method.
		#I know it's not right to hard code is a number here.... have to fix this later!
		@is_field = true
		@setter = setter
		@object = get

		#...clearly, i need more flexible (g/s)etting.
		#it's the parent which controls the setting and getting anyway.
		#so that information doesn't belong here.
	else
		@is_action = true
		#result action will be called with the return value of the action.
#		puts "ACTION RESULT: #{result_action}"
		if result_action.is_a? Symbol or result_action.is_a? String then
			@result_action = @parent.method(result_action)
		elsif result_action.is_a? Proc then
			raise "result_action is a Proc: #{result_action} Proc's not supported yet"
		else
			raise "result action must be #{String} or #{Symbol}. #{Proc} coming soon. \nresult action was: #{parent}.#{getter}->#{result_action.inspect} for"
		end
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
		raise "#{self} does not have members"
	end
end
	#members works - else throws exception.
	#members returns a list of viewers
def openable?
#	@builder ? @builder.viewer(@object) : nil
	nil
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
		has_members? == other.has_members? and
		types == other.types
	then return false end
	if is_field? and get != other.get 
	then return false end
	if has_members? and members != other.members
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

def nest(object)
	puts "build a viewer around #{object}..."
	raise "cannot nest #{object} (#{object.class}) mid-layer builder not implemented yet"
	ap self
end
def open(object)
	puts "build a viewer around #{object}..."
#	raise "cannot open #{object} (#{object.class}) mid-layer builder not implemented yet"
	builder.build(object)
end
def refresh(object = nil)
#	puts "refreshing..."
	if is_field? then
#		puts "----#{name}=#{get}"
	@object = get
	end
	if has_members? then
#		puts "----refresh members"
		members.each{|m| m.refresh}
	end
#	ap self
end
def ignore(object)
end
def is_action?
	@is_action
end
def call 
	if is_action? then
		#here, we call the action_responce.
		@result_action.call(@parent.get_field(@name))
	else
		raise "!#{self}.is_action? cannot .call"
	end
end

def to_s
	
	unless has_members? then
		if is_action? then
			"()->#{@result_action.inspect}"
		else
		object.to_s
		end
	else
		s = "v(\n"
		s << members.collect{|m|
			ms = m.to_s.gsub("\n","\n  ")
			"  #{m.name}=#{ms}"
		}.join("\n")
		s << ")"
	end
end
end
