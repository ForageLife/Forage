require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

File.open(File.expand_path(File.dirname(__FILE__)) + "/lifestyles.txt", "r").each_line do |line|
  data = line.split(/\t/)
  name = data[0]
  data.map! { |x| x.to_i == 1 ? true : false }
  new_food_category = FoodCategory.new({name:name, vegetarian:data[1], vegan:data[2], dairy_free:!data[3], gluten_free:!data[4], nut_free:!data[5]})
  new_food_category.save
end