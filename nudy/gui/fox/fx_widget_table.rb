require 'fox16'
require 'fox/fx_widget_row'

module Fox
class FXWidgetTable < FXVerticalFrame
	attr_accessor :header_names

	def initialize (container, header, flags = 0, *args)
		super(container,flags|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH|PACK_UNIFORM_HEIGHT,*args)
		@header_names = header
		@rows = []
 		@header_widget = FXHeader.new(self, 
 			:opts => HEADER_NORMAL|HEADER_BUTTON|HEADER_RESIZE|LAYOUT_FIX_X)#|LAYOUT_FIX_Y)
		@header_widget.height = 50
		setPadLeft(0)
		setVSpacing(0)

		@header_widget.connect(SEL_CHANGED) do |sender, sel, which|
 			update_widths
		end
#    @header1.connect(SEL_COMMAND) do |sender, sel, which|
 #     @lists[which].numItems.times do |i|
  #      @lists[which].selectItem(i)
   #   end
    #end 

		@row_widgets = []
		add_column("*")
		@header_names.each{|e| add_column(e)}
		self.set_widths(20)

#		FXHorizontalSeparator.new(self,SEPARATOR_LINE|LAYOUT_FILL_X)
	end
	def update_widths
		@row_widgets.each{|r| r.set_widths(*widths)}
	end
	def widths
	i = @header_widget.numItems
		ws = []
		i.times{|c| ws << @header_widget.getItemSize(c)}
	ws
	end
	def add_column(name, index=-1)
		@header_widget.appendItem("#{name}", nil, 100)
		
		#under the header are N vertical frames, (columns) 
		#with width set to match headers.
		#widgets fit into that. LAYOUT_FILL_X
		#and height set to be same.

		#if a list changes, then redraw

		#have a map from headers to columns.
		#create column in table.
	end
#	def width
#		sum = 0
#		widths.each{|w| sum += w}
#		sum
		400
#	end
	def setWidth(w_new)
		w_old = 0.0
		w_new = 1.0 * w_new
		widths.each{|w| w_old += w}
		ws = widths
		puts "total width=#{w_new} old_width #{w_old} ratio change=#{w_new/w_old}"
		#setW(w)
		ws.collect!{|c| c*(w_new/w_old)}
		set_widths(*ws)
	end
	def add_row(array)
		@rows << array
		@row_widgets << w = FXWidgetRow.new(self,array)
		w.setY(100)
		#hey! this is where an array with change listeners would come in handy.
	end
	def rows
		@rows
	end
	def set_widths(*wid)
		i = @header_widget.numItems
		total = 0
		(0..wid.length - 1).each{|i|
			puts wid[i].inspect
			total += wid[i]
			@header_widget.setItemSize(i,wid[i])
		}
		#self.setWidth(total)
		width=total
		@row_widgets.each{|r| r.set_widths(*wid)}
	end
end

if $0 == __FILE__ then

application = FXApp.new("Hello", "FoxTest")
main = FXMainWindow.new(application, "Hello", nil, nil, DECOR_ALL)
	main.setHeight(100)
	main.setWidth(500)
	row = ["this","is","one","row"]
	table = FXWidgetTable.new(main,row)
	table.add_row row
	table.add_row row.dup
	table.add_row row.dup
	#table.set_widths(120,20,200,60)
	table.setWidth(300)
	main.update
application.create()
main.show(PLACEMENT_SCREEN)
application.run()
end
end
