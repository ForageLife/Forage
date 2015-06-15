class CreateFoodCategories < ActiveRecord::Migration
  def change
    create_table :food_categories do |t|
      t.string :name
      t.boolean :vegetarian
      t.boolean :vegan
      t.boolean :dairy_free
      t.boolean :gluten_free
      t.boolean :nut_free

      t.timestamps null: false
    end
  end
end
