class Window < Wee::Component

  attr_accessor :title, :pos_x, :pos_y

  def initialize(&block)
    super()
    @status = :normal  
    @pos_x, @pos_y = "0px", "0px"
    @children = []
    block.call(self) if block
  end

  def <<(c)
    @children << c
  end

  def children() @children end

  def state(s)
    super
    s.add_ivar(self, :@status, @status)
  end

  def process_callbacks(callbacks)
    return if @status == :closed
    super
  end

  def render(r)
    return if @status == :closed

    r.table.cellspacing(0).style("border:solid 1px grey; position: absolute; left: #{@pos_x}; top: #{@pos_y};").with do
      r.table_row.style("background-color: lightblue; width: 100%").with do
        r.table_data.style("text-align: left; width: 66%").with(@title)
        r.table_data.style("text-align: right").with do
          if @status == :minimized
            r.anchor.callback{maximize}.with("^")
          else
            r.anchor.callback{minimize}.with("_")
          end
          r.space
          r.anchor.callback{close}.with("x")
        end
      end
      r.table_row do
        r.table_data.colspan(2).with do
          if @status == :normal
            for child in self.children do
              r.render(child)
            end
          end
        end
      end
    end
  end

  public 

  def minimize
    @status = :minimized
  end

  def maximize
    @status = :normal
  end

  def close
    @status = :closed
  end

end
