require 'nudy/object_viewer'

#this class will build viewers around domain objects.
#you say things like:
#ib = InterfaceBuilder.new

#ib.add(Person).view_class(ObjectViewer).add_fields(:name.:height,:age,:liar).add_actions(:chop,:randomize)

#and then, when somebody says

#ib.create(Person.new)

#ib will know, hey, this is a Person, for Person's I use ObjectViewer with the following classes...

#sometimes it will be necessary to have objects in a particular window handled specially.
#sometimes a viewer will want to create more viewers later. (i.e. open a dialog box to edit a reference object)


#stop coding, write a test!

class ViewBuildPlan
	attr_accessor :klass,:actions,:fields,:view_class, :builder, :default_fields
	def initialize(view_class = nil)
#		@klass = klass
		@view_class = view_class
		@actions = []
		@fields = []
		@default_fields = false
	end
	def builder(interfacebuilder)
		@builder = interfacebuilder
		self
	end
	def add_actions(*action)
		@actions = @actions + action
		self
	end
	def add_fields(*field)
		@fields = @fields + field
		self
	end
	def get(object,field)
		object.method(field.to_s).call
	end
	def add_default_fields(viewer)
#		add_fields(*@klass.instance_methods.find_all{|it| 
#		m = it + "="
#		if @klass.instance_methods.include?(m) then
#			if @klass.instance_method(it).arity == 0 and @klass.instance_method(m).arity == 1 then
#				true
#			end
#		end
#	})

	end
	def build(object)
		if @view_class.nil? then
			raise "cannot #{self}.build. Viewer to use not set. call #{self}.use(ViewClass) first!"
		end
		v = @view_class.new(object)
		puts "build: #{object}"
		@fields.each {|e| 
			v.add_fields(
				@builder.build_field(object,e))
		}
		@actions.each{|e|
			v.add_actions(Action.new(object,e))#there arn't multiple action types yet... maybe should think of an action as a write only field?
		}
		v
	end
	def build_field(parent,name)
		if @view_class.nil? then
			raise "cannot #{self}.build. Viewer to use not set. call #{self}.use(ViewClass) first!"
		end
		v = @view_class.new(parent,name)
		puts "build_field: #{parent},#{name}"
		v
	end
	def use(view_class)
		@view_class = view_class
	end
end

# there needs to be a seperate interface builder and member builder.
# for example,
# one time you have a Object, and you want a window which you use to edit that Object. in the other, you want to make a button, 
# which opens a window in which you edit the object. 

#the interface builder knows, for a given class:
#	-what fields something should have
#	-what field builder(s) to use
#	-what interface builder to assign to the viewers
#	-what fields NOT to use.
#(think about assigning interface builders to specific fields later.)

#the member builder knows
#	-member owner
#	-method name.
#	-conventions - attr&attr= (read/write), action! (changes state), 
#	-arity
#[could make field builder which only responds to particular names.]

#member builders can be different. 
#have a list of builders, find the first one which knows what to do with a field.

class InterfaceBuilder
	attr_accessor :parent, :plans
	def initialize (parent = nil)
	@parent = parent
	@plans = Hash.new
	end
	def add(klass,*viewers)
		vbp = ViewBuildPlan.new(klass).builder(self)
		viewers.each{|e| @plans[e] = vbp}
		vbp
	end
	def build(object)

		klass = @plans[object.class]
		puts "BUILD :: #{object} ---- #{klass}" 
		
		if klass.nil? then
				puts "klass.nil?"
	
			if @parent then
				puts "BUILD WITH PARENT:"
				return @parent.build(object) 
			end
			raise "#{self} has no #{ViewBuildPlan} for #{object} (#{object.class})"
		end
		viewer = klass.build(object)
	end
	def build_field(parent,name)#this doesn't feel like it's the best way to do setup fields... but I think it's working for now.
		object = parent.method(name).call
		klass = @plans[object.class]
		if klass.nil? then
			if @parent then
				puts "BUILD WITH PARENT:"
				return @parent.build_field(parent,name) 
			end
			raise "#{self} has no #{ViewBuildPlan} for #{object} (#{object.class})"
		end
		viewer = klass.build_field(parent,name)
	end
end

