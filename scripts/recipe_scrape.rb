require 'mechanize'
require 'open-uri'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

mechanize = Mechanize.new
for pagination in (1..1000).to_a
	recipes_page = mechanize.get("http://allrecipes.com/recipes/main.aspx?vm=l&evt19=1&p34=HR_ListView&Page=#{pagination}#recipes")
	recipe_links = recipes_page.search "//h3[@class='resultTitle']/a"
	for recipe_link in recipe_links
		recipe = Recipe.new
		recipe = Recipe.new
		recipe.vegetarian = true
		recipe.vegan = true
		recipe.dairy_free = true
		recipe.gluten_free = true
		recipe.nut_free = true
		recipe_page = Mechanize::Page::Link.new( recipe_link, mechanize, recipe_page ).click
		ingredient_list = recipe_page.search "//p[@class='fl-ing']"
		recipe_name = recipe_page.search("//h1[@id='itemTitle']").text.downcase
		recipe_directions = recipe_page.search("//div[@itemprop='recipeInstructions']").text.downcase
		recipe_image = recipe_page.search("//img[@id='imgPhoto']").first.attributes["src"].value
		ingredients = []
		for ingredient in ingredient_list
			string_array = ingredient.css('#lblIngAmount').text.split(" ")
			ingredient_amount = 0
			ingredient_metric = ""
			for substring in string_array
				if substring.include? "("
					substring.delete! "("
					ingredient_amount *= substring.to_r.to_f
				elsif substring.include? ")"
					substring.delete! ")"
					ingredient_metric += substring + " "
				elsif substring == substring[/[a-zA-Z]+/]
					ingredient_metric += substring + " "
				else
					ingredient_amount += substring.to_r.to_f
				end
			end
			ingredient_amount = ingredient_amount.to_s
			if !ingredient_amount.nil?
				ingredient_amount = ingredient_amount.downcase
			end
			if !ingredient_metric.nil?
				ingredient_metric = ingredient_metric.downcase
			end
			ingredient_name = ingredient.css('#lblIngName').text.split(',')[0].downcase
			ingredient_check = Ingredient.find_by name: ingredient_name
			if ingredient_check.nil?
				ingredient_check = Ingredient.new
				ingredient_check.name = ingredient_name
				ingredient_check.count = 1
			else
				ingredient_check.increment(:count)
			end
			food_category = FoodCategory.find_by name: ingredient_name
			if !food_category.nil?
				if !food_category.vegetarian
					recipe.vegetarian = false
				end
				if !food_category.vegan
					recipe.vegan = false
				end
				if !food_category.dairy_free
					recipe.dairy_free = false
				end
				if !food_category.gluten_free
					recipe.gluten_free = false
				end
				if !food_category.nut_free
					recipe.nut_free = false
				end
			end
			ingredient_check.save
			ingredients << {ingredient_amount:ingredient_amount, ingredient_metric:ingredient_metric, ingredient_name:ingredient_name}
		end
		recipe.name = recipe_name
		recipe.directions = recipe_directions
		recipe.food_image = open(recipe_image)
		recipe.ingredients = ingredients
		recipe.save
	end
end

mechanize = Mechanize.new
for pagination in ["123", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "XYZ"]
	for sub_pagination in (1..100).to_a
		recipes_page = mechanize.get("http://www.foodnetwork.com/recipes/a-z.#{pagination}.#{sub_pagination}.html")
		recipe_links = recipes_page.search "//li[@class='col18']/span[@class='arrow']/a"
		for recipe_link in recipe_links
			recipe = Recipe.new
			recipe.vegetarian = true
			recipe.vegan = true
			recipe.dairy_free = true
			recipe.gluten_free = true
			recipe.nut_free = true
			recipe_page = Mechanize::Page::Link.new( recipe_link, mechanize, recipe_page ).click
			ingredient_list = recipe_page.search "//li[@itemprop='ingredients']"
			recipe_name = recipe_page.search("//h1[@itemprop='name']").text.downcase
			recipe_directions = recipe_page.search("//div[@itemprop='recipeInstructions']").text.downcase
			image_array = recipe_page.search("//img[@itemprop='image']").first
			if !image_array.nil?
				recipe_image = open(image_array.attributes["src"].value)
				recipe.food_image = recipe_image
			end
			ingredients = []
			for ingredient in ingredient_list
				pre_process_ingredient = ingredient.text
				ingredient_words = pre_process_ingredient.split(',')[0].split(" ")
				potential_ingredient_amount = ingredient_words[0]
				if /\A\d+\z/.match(potential_ingredient_amount) or ["one","two","three","four","five","six","seven","eight","nine"].include?(potential_ingredient_amount.downcase)
					ingredient_amount = potential_ingredient_amount.downcase
					ingredient_metric = ingredient_words[1].downcase
					ingredient_name = ingredient_words[2..ingredient_words.length].join(' ').downcase
				else
					ingredient_amount = nil
					ingredient_metric = nil
					ingredient_name = pre_process_ingredient.downcase
					ingredient_check = Ingredient.find_by name: ingredient_name
					if ingredient_check.nil?
						ingredient_check = Ingredient.new
						ingredient_check.name = ingredient_name
						ingredient_check.count = 1
					else
						ingredient_check.increment(:count)
					end
					food_category = FoodCategory.find_by name: ingredient_name
					if !food_category.nil?
						if !food_category.vegetarian
							recipe.vegetarian = false
						end
						if !food_category.vegan
							recipe.vegan = false
						end
						if !food_category.dairy_free
							recipe.dairy_free = false
						end
						if !food_category.gluten_free
							recipe.gluten_free = false
						end
						if !food_category.nut_free
							recipe.nut_free = false
						end
					end
					ingredient_check.save
				end
				ingredients << {ingredient_amount:ingredient_amount, ingredient_metric:ingredient_metric, ingredient_name:ingredient_name}
			end
			recipe.name = recipe_name
			recipe.directions = recipe_directions
			recipe.ingredients = ingredients
			recipe.save
		end
	end
end