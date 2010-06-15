
require 'nudy/options'
require 'nudy/reference'

class FoxFactory
	def self.field(container,f)#remove as much decision making to the middle layer.
		t = f.field_type
		if Numeric >= t   then
			FoxFloat.new(container,f)
		elsif TrueClass >= t or FalseClass >= t then
			FoxBoolean.new(container,f)
		elsif String == t  then
			FoxString.new(container,f)
		elsif f.is_a? Options
			puts ">>>FoxOptions"
			FoxOptionsField.new(container,f)
		elsif f.is_a? Reference
			FoxReferenceField.new(container,f)
		end
	end
	def self.action(container,a)
		FoxAction.new(container,a)
	end
	def self.viewer(container,vfa)
		if vfa.is_a? Field then
			self.field(container,vfa)
		elsif vfa.is_a? Action then
			self.action(container,vfa)
		elsif vfa.is_a? Viewable then #a constant would make a more lightweight convention.
			FoxObjectDisplay.new(container,vfa)
		end
	end
end

	class FoxField
		def update
			@textfield.text = @field.get.to_s
		end
		def create(container,f,t = 0)
			@field = f
			@textfield = 
			field_name = FXLabel.new(container,f.name.to_s, nil, LAYOUT_LEFT|JUSTIFY_CENTER_X)
			@textfield = FXTextField.new(container, 20, nil, 0, JUSTIFY_LEFT|LAYOUT_SIDE_TOP|t)
			update
			@textfield.connect(SEL_COMMAND) {|value,id,str|
				puts "#{f} =>#{value.inspect}"
				f.set(value)
			}
			@field.watch(self)
		end
		def initialize (container,f)
			create(container,f)	
		end
	end
	class FoxInteger < FoxField
		def initialize(c,f)
			create(c,f,TEXTFIELD_INTEGER)
		end
	end
	class FoxFloat < FoxField
		def initialize(c,f)
			create(c,f,TEXTFIELD_REAL)
		end
	end
	class FoxString < FoxField
	end
	class FoxBoolean < FoxField
		def update
			@check.setCheck (@field.get ? TRUE : FALSE)
		
		end
		def initialize (container,f)
			@field = f
			@check = FXCheckButton.new(container, f.name.to_s, nil, 0, ICON_BEFORE_TEXT|LAYOUT_SIDE_TOP)
			@check.connect(SEL_COMMAND) {|value,id,str|
				puts "#{f} =>#{value.inspect} #{id}, #{str}"
				f.set(str)
			}
			@field.watch(self)
		end
	end
	class FoxAction < Fox::FXButton
		def initialize (container,action)
			super(container, action.name.to_s, nil, nil, 0, FRAME_RAISED|FRAME_THICK)
			connect(SEL_COMMAND) {|value,id,str|
				puts "action: #{action.name}()"
				action.call
				#hmm. this is the point where it should update?
				container.update
			}
		end
	end
	class FoxOptionsField < Fox::FXOptionMenu#options would also make sense as radio buttons.
		def initialize (container,field)
			puts ">>>>FoxOptionsField"	
			field_name = FXLabel.new(container,field.name.to_s, nil, LAYOUT_LEFT|JUSTIFY_CENTER_X)
			pop = Fox::FXPopup.new(container)

			field.options.each{|opt|
			puts "option:#{opt}"
		      	FXOption.new(pop, opt.to_s, :opts => JUSTIFY_HZ_APART|ICON_AFTER_TEXT).
				connect(SEL_COMMAND){field.set(opt)}
			}
			super(container,pop)
		end
#		def setup(field)
#		end
	end
	class FoxReferenceField < Fox::FXButton

		#OOPS!
		def initialize (container,field)
			super(container, "#{field.name}: #{field.get.to_s}", nil, nil, 0, FRAME_RAISED|FRAME_THICK)
			connect(SEL_COMMAND) {|value,id,str|
				FoxReferenceDialog.new(container,field).execute
				container.update
			}
		end
	end

	class FoxReferenceDialog < Fox::FXDialogBox
		def initialize (container, viewer)
			#call interface layer factory to make viewer(field.get)
			super(container, "#{container.name}>#{viewer.title}", DECOR_TITLE|DECOR_BORDER) #,:width => 400, :height => 200)

			buttons = FXHorizontalFrame.new(self,
			LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH,
			:padLeft => 40, :padRight => 40, :padTop => 20, :padBottom => 20)
			# Separator
			FXHorizontalSeparator.new(self,
			LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|SEPARATOR_GROOVE)
 
			# Contents
			contents = FXHorizontalFrame.new(self,
			LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH)
			FoxFactory.viewer(contents,viewer)

			accept = FXButton.new(buttons, "&Accept", nil, self, ID_ACCEPT,
		 	FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
			# Cancel
			FXButton.new(buttons, "&Cancel", nil, self, ID_CANCEL,
			FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
   
			accept.setDefault
			accept.setFocus
		end
	end

class FoxObjectDisplay < Fox::FXGroupBox
	attr_accessor :viewer, :fields, :name
	def update
		#when this is called, 
		#update all fields.
		@members.each {|e| e.update}
		#call all sub fields? (they arn't stored yet.)
		# or rebuild all the components?
#		destroy
	end
	def initialize (container,viewer)
		#if container isn't a fox container raise an exception with an informative messsage
		@viewer = viewer
		@members = []
		@name = viewer.title
		#wrap everything in a groupbox, and then use the FoxFactory to load the fields and actions.
		super(container, viewer.title,GROUPBOX_TITLE_LEFT|FRAME_RIDGE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
#		g = FXGroupBox.new(container, viewer.title,GROUPBOX_TITLE_LEFT|FRAME_RIDGE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
		puts "MEMBERS: #{viewer.members.inspect}"
		viewer.watch(self)
				
		viewer.members.each{|e|
			puts "#{e.name} = #{e.get} (#{e.get.class})"
			@members << FoxFactory.viewer(self,e)
		}
	end

end

class FoxObjectDisplay2 
	attr_accessor :viewer
	def update
		#when this is called, 
		#update all fields.
#		@fields.each {|e| e.update}
	end
	def initialize (container,viewer)
		#if container isn't a fox container raise an exception with an informative messsage
		@viewer = viewer
		#wrap everything in a groupbox, and then use the FoxFactory to load the fields and actions.
		
		g = FXGroupBox.new(container, viewer.title,GROUPBOX_TITLE_LEFT|FRAME_RIDGE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
		puts viewer.fields.inspect
				
		viewer.members.each{|e|
			puts "#{e.name} = #{e.get} (#{e.get.class})"
			FoxFactory.viewer(g,e)
		}

	end

end
