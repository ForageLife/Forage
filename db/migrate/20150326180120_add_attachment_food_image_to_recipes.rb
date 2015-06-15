class AddAttachmentFoodImageToRecipes < ActiveRecord::Migration
  def self.up
    change_table :recipes do |t|
      t.attachment :food_image
    end
  end

  def self.down
    remove_attachment :recipes, :food_image
  end
end
