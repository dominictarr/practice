require 'fox16'

module Fox
class FxWidgetTable < FXVerticalFrame
	attr_accessor :header_names

	def initialize (container, header, flags = 0, *args)
		super(container,flags,*args)
		@header_names = header
 		@header_widget = FXHeader.new(self, 
 			:opts => HEADER_BUTTON|HEADER_RESIZE|LAYOUT_FILL_X)
		@header_widget.connect(SEL_CHANGED) do |sender, sel, which|
 			#@lists[which].width = @header_widget.getItemSize(which)
		end
#    @header1.connect(SEL_COMMAND) do |sender, sel, which|
 #     @lists[which].numItems.times do |i|
  #      @lists[which].selectItem(i)
   #   end
    #end 
		@header_names.each{|e| add_column(e)}
	end
	def add_column(name, index=-1)
#		@header_widget.appendItem(name,nil,90)
    @header_widget.appendItem("#{name}", nil, 140)
		#create column in table.
	end
	def add_row(array)
		@rows << array
		#hey! this is where an array with change listeners would come in handy.
	end
	def get_rows
		
	end
	def set_widths(*width)
		(0..width.length).each{|i|
			@header_widget.setSize(i,width[i])
		}
	end
end;end
