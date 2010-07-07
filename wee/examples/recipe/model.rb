require 'rubygems'
require 'sequel'
$LOAD_PATH.unshift "../../lib"
require 'wee'

DB = Sequel.postgres :database => 'cookbook', :user => 'mneumann',
  :password => '', :host => '/var/run/postgresql'

require 'models/recipe'
require 'recipe_editor'

Sequel::Migrator.apply(DB, 'migrations')

class MainPage < Wee::Component
  def initialize
    super()
    @child = add_child RecipeEditor.new(Recipe.new)
  end

  def render(r)
    r.page.title('Recipes').with {
      r.render @child
    }
  end
end

Wee.run(MainPage)
