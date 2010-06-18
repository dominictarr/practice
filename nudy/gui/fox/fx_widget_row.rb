require 'fox16'
require 'fox16/colors'

include Fox
module Fox
class FXWidgetRow < FXHorizontalFrame

	def add_field(value)
		puts value
		tf= FXTextField.new(self, 5, nil, 10,LAYOUT_FIX_WIDTH)#, JUSTIFY_LEFT|LAYOUT_SIDE_LEFT|LAYOUT_FILL_Y)
		if @colour then
		     tf.backColor = FXColor::Red
		else
		     tf.backColor = FXColor::Green
		end
		tf.height = 50
		tf.setPadLeft(0)
		tf.setPadRight(0)	

		@colour = !@colour

		tf.text = value.to_s

	end
	def row_data
		children.collect {|c| c.text}
	end
	def initialize (container, header, flags = 0, *args)
		@colour = true
		super(container,flags|LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X)
		setPadLeft(0);setPadRight(0);setPadTop(0);setPadBottom(0)
		setHSpacing(0)
		setVSpacing(0)

		tf= FXLabel.new(self, "*",nil,LAYOUT_FIX_WIDTH|JUSTIFY_LEFT)
		tf.setWidth(20)
		header.each{|h|
			add_field(h)
		}
	end
#	def setWidth(total
	def set_widths(*width)
		total = 0
		(0..width.length - 1).each{|i|
			puts width[i]
			total += width[i]
			childAtIndex(i).setWidth(width[i])
		}
#		self.setWidth(total)
	end
	def shift_right(index)
		#puts index
		#puts "#{childAtIndex(index)}-after>#{childAtIndex(index+1)}"
		unless index == children.length - 1 then
			childAtIndex(index).linkAfter(childAtIndex(index+1))
		end
	end
	def shift_left(index)
		index == 0 ? nil : childAtIndex(index).linkBefore(childAtIndex(index+-1))
	end
	def shift_after(from,to)
		childAtIndex(from).linkAfter(childAtIndex(to))
	end
	def shift_before(from,to)
		childAtIndex(from).linkBefore(childAtIndex(to))
	end

end

if $0 == __FILE__ then

application = FXApp.new("Hello", "FoxTest")
main = FXMainWindow.new(application, "Hello", nil, nil, DECOR_ALL)

	row = FXWidgetRow.new(main,["this","is","one","row","this","is","one","row"])
	row.set_widths(120,20,200,60,20,20,34,23)
	main.update
application.create()
main.show(PLACEMENT_SCREEN)
application.run()
end
end
