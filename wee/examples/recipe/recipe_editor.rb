class RecipeEditor < Wee::Component
  def initialize(instance)
    super()
    @instance = instance 
  end

  def render(r)
    if @instance.new?
      r.h1("New #{@instance.class}")
    else
      r.h1("Edit #{@instance.class}")
    end

    r.form do 
      r.text "Title"
      r.break
      r.text_input.value(@instance.title || '').callback{|v| @instance.title = v}
      r.paragraph

      r.text "Instructions"
      r.break
      r.text_area.callback{|v| @instance.instructions = v}.with(@instance.instructions || '')
      r.paragraph

      r.submit_button.value(@instance.new? ? 'Create' : 'Update').callback { @instance.save }
    end 
  end
end
