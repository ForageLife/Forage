class Recipe < ActiveRecord::Base
  has_attached_file :food_image
  validates_attachment_content_type :food_image, :content_type => /\Aimage\/.*\Z/
  serialize :ingredients
end
