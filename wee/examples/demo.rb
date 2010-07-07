$LOAD_PATH.unshift "../lib"
require 'rubygems'
require 'wee'

$LOAD_PATH.unshift "./demo"
require 'demo/calculator'
require 'demo/counter'
require 'demo/calendar'
require 'demo/radio'
require 'demo/file_upload'

class Demo < Wee::Component
  class E < Struct.new(:component, :title, :file); end

  def initialize
    super
    add_decoration Wee::PageDecoration.new('Wee Demos')

    @components = [] 
    @components << E.new(Counter.new, "Counter", 'demo/counter.rb')
    @components << E.new(Calculator.new, "Calculator", 'demo/calculator.rb')
    @components << E.new(CustomCalendarDemo.new, "Calendar", 'demo/calendar.rb')
    @components << E.new(RadioTest.new, "Radio Buttons", 'demo/radio.rb')
    @components << E.new(FileUploadTest.new, "File Upload", 'demo/file_upload.rb')

    @editor = Editor.new

    select_component(@components.first)
  end

  def children
    @components.map {|c| c.component} + [@editor]
  end

  def select_component(component)
    @editor.entry = @selected_component = component
  end

  def render(r)
    r.form.enctype_multipart.with do
      r.h1 'Wee Component Demos' 
      r.div.style('float: left; width: 200px;').with {
        r.select_list(@components).
          labels(@components.map {|c| c.title}).
          selected(@selected_component).
          size(10).
          onclick_javascript("this.form.submit()").
          callback_method(:select_component)
        r.break
        r.checkbox.checked(@editor.visibility).
          onclick_javascript("this.form.submit()").
          callback {|bool| @editor.visibility = bool }
        r.space
        r.text "Show Sourcecode?"
        r.break
      }
      r.div.style('float: left; left: 20px; height: 200px; width: 600px; background: #EFEFEF; border: 1px dotted red; padding: 10px').with {
        r.render @selected_component.component
      }
      r.render @editor
    end
  end

  class Editor < Wee::Component
    attr_accessor :visibility
    attr_accessor :entry

    def initialize
      super
      @visibility = false
      @mode = :view
      @entry = nil
    end

    def save
      File.open(@entry.file, 'w+') {|f| f << @txt.lines.map {|l| l.chomp}.join("\n") + "\n" }
      load @entry.file
      @mode = :view
    end

    def render(r)
      return unless @visibility
      r.div.style('float: left; margin-top: 2em; border-top: 2px solid; width: 100%').with {
        if @mode == :view
          r.anchor.callback { @mode = :edit }.with('edit')
          r.pre.ondblclick_callback { @mode = :edit }.with {
            r.encode_text(File.read(@entry.file))
          }
        else
          r.form do
            r.anchor.callback { @mode = :view }.with('cancel'); r.space
            r.submit_button.callback_method(:save).value('Save!')
            r.break
            r.text_area.rows(25).cols(120).callback{|txt| @txt = txt }.with {
              r.encode_text(File.read(@entry.file))
            }
          end
        end
      }
    end
  end

end

Wee.run(Demo) if __FILE__ == $0
