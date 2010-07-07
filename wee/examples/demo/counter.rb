class Counter < Wee::Component
  attr_accessor :count

  def initialize(initial_count=100)
    super()
    @count = initial_count 
  end

  def state(s)
    super
    s.add_ivar(self, :@count, @count)
  end

  def dec
    @count -= 1
  end

  def inc
    @count += 1
  end

  def render(r)
    r.once(self.class) {
      r.css ".wee-Counter a { border: 1px dotted red; margin: 2px; }"
    }
    r.h2 "hello -asd muthafucker!!!!"
    r.div.id("wee-#{object_id.to_s(36)}").css_class('wee-Counter').with {
      r.anchor.callback_method(:dec).with("--")
      r.space
      render_count(r)
      r.space
      r.anchor.callback_method(:inc).with("++")
    }
  end

  def render_count(r)
    r.text @count.to_s
  end
end
