class CreateRecipes < Sequel::Migration
  def up
    create_table :recipes do
      primary_key :id
      text :title
      text :instructions
    end
  end

  def down
    drop_table :recipes
  end
end
