$LOAD_PATH.unshift "../lib"
require 'rubygems'
require 'wee'

class Page < Wee::Component
  def initialize
    add_decoration Wee::PageDecoration.new('Title')
    super
  end
  def render(r)
    r.anchor.callback {
      if callcc YesNoMessageBox.new('Really delete?')
        callcc InfoMessageBox.new('Deleted!')
      else
        callcc InfoMessageBox.new('Deleted action aborted')
      end
    }.with("delete?")
  end
end

class InfoMessageBox < Wee::Component
  def initialize(msg)
    @msg = msg
    super()
  end

  def render(r)
    r.h1(@msg)
    r.anchor.callback { answer }.with('OK')
  end
end

class YesNoMessageBox < InfoMessageBox
  def render(r)
    r.h1(@msg)
    r.anchor.callback { answer true }.with('YES')
    r.space(1)
    r.anchor.callback { answer false }.with('NO')
  end
end

Wee.runcc(Page)
