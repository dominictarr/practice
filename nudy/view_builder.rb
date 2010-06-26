class ViewBuilder

attr_accessor :parent, :children,:head

def initialize (head, tail = [])
	@head = head
	@children = tail
	if @head then @head.set_parent(self) end
	tail.each{|f| f.set_parent(self)}
end
def set_parent(parent)
	if !@parent then
		@parent = parent
	end
end
def handles?(object) 
	@head? @head.handles?(object) : nil
end
def child_handles?(object)
	c = @children.find{|f| f.handles?(object)}
	c ? c.head : nil
end
def ancestor_handles?(object)
	if @parent then
		c = @parent.child_handles?(object)
		c || @parent.ancestor_handles?(object)
	else
		raise "#{self} has no parent #{ViewBuilder}"
	end
end
def build_view (object)
	@head.build(object)
end
def build_member(object)
	view_def = child_handles?(object) || ancestor_handles?(object)
	if view_def.nil? then
		raise "has no #{ViewDef} which handles #{object} (#{object.class})"
	end
	view = view_def.build(object)
	add_members(view,view_def,object)
	view
end
#damn, I think that is all the functionality. oh hang on:

def add_members (view,view_def,object)
	unless view_def.as_field then 
	#build members, if this isn't meant to be a field.
		view_def.members_for(object).each{|f|
#			puts "building member: #{f}"
			unless f.is_a? Array then
				obj = view.get_field(f)
#			puts "	#{f}-> #{obj.inspect}"
				view.add_members(m = view_def.builder.build_member(obj).set_control(view,f))
			else
				view.add_members(m = view_def.builder.build_member(nil).set_control(view,*f))
			end
			m.builder = self
		}
	end

end

def build(object)
	vb = handles?(object) ? @head : nil || child_handles?(object) || ancestor_handles?(object)
	if vb.nil? then
		raise "#{self} does not have a way to build viewer for #{object}"
	end
	v = vb.build(object)
#	puts "members_for: #{vb.members_for(object).inspect}"
	v.builder=self
	add_members(v,vb,object)
	v
end


end
