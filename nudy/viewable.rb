class Viewable
	attr_accessor :members, :object, :title, :u_i_viewers,:builder
	def initialize (object)
		@members = []
		@object = object
		@title = object.class.to_s
		@u_i_viewers = []
		@builder
	end
	def member (name) #returns member with name, else returns nil
		if name.is_a? String or name.is_a? Symbol then
		@members.find { |it| it.name == name.to_s}
		else 
		@members.find { |it| it == name}
		end
	end
	def add_members(*members)
		members.each{|f| @members << f}
		self
	end

	def watch(viewer)
		unless viewer.method("update") and viewer.method("update").arity == 0 then
			raise "viewer #{viewer} does not have an 'update' method"
		end
		unless @viewers then  @viewers = []; end
		@viewers << viewer
	end
	def update
		puts "UPDATE!"
		if @viewers then
			@viewers.each{|u| u.update}
		end
	end
end

