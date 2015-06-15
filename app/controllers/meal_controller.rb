class MealController < ApplicationController
	respond_to :json
	def index
		ingredients = params[:ingredients]
		unless ingredients
			ingredients = ["garlic"]
		end
		# weight the ingredients by order they were entered 
		weighted_ingredients = ingredients.each_with_index.map{|ingredient, idx| {name: ingredient, weight: (1+0.1/(idx+1))}}
		ranked_recipes = []
		lifestyle_string = ""
		for lifestyle in ["vegetarian","vegan","dairy_free","gluten_free","nut_free"]
			if params[lifestyle] == "true"
				lifestyle_string = lifestyle_string + "recipe.#{lifestyle} and "
			end
		end
		if lifestyle_string.length == 0
			lifestyle_string = "true"
		else
			lifestyle_string = lifestyle_string[0..-6]
		end
		# fetch recipes that adhere to lifestyle checkboxes
		lifestyle_viable_recipes = Recipe.select {|recipe| eval(lifestyle_string)}
		for recipe in lifestyle_viable_recipes
			total_weight = 0
			for ingredient in recipe.ingredients
				match = weighted_ingredients.detect {|weighted_ingredient| weighted_ingredient[:name] == "#{ingredient[:ingredient_name]}"}
				if !match.nil?
					total_weight = total_weight + match[:weight]
				end
			end
			if total_weight > 0
				# weight each recipe off it's weighted ingredients
				ranked_recipes << {id: recipe.id, weight: total_weight}
			end
		end
		top_match_id = ranked_recipes.max_by{|recipe| recipe[:weight]}[:id]
		top_recipe_ingredients = Recipe.find(top_match_id)[:ingredients].map{|ingredient| ingredient[:ingredient_name]}
		top_recipe_ingredients_length = top_recipe_ingredients.length
		ideal_matches = (params[:crossover_slider].to_i/100)*(top_recipe_ingredients_length)
		matched_recipes = []
		# fetch recipes that have the correct crossover % with top match
		for recipe in lifestyle_viable_recipes
			crossover_disparity = (ideal_matches - (top_recipe_ingredients & recipe[:ingredients].map{|ingredient| ingredient[:ingredient_name]}).length).abs
			matched_recipes << {id: recipe[:id], crossover_disparity: crossover_disparity}
		end
		crossover_sorted_recipes = matched_recipes.sort_by{|k| k[:crossover_disparity]}
		crossover_sorted_recipes.delete_if {|h| h[:id] == top_match_id}
		meal_ids = crossover_sorted_recipes[0..3].map{|recipe| recipe[:id]}
		meal_ids << top_match_id
		weeks_meals = []
		for id in meal_ids
			recipe = Recipe.find(id)
			recipe_attributes = recipe.attributes
			recipe_attributes[:food_url] = recipe.food_image.url
			weeks_meals << recipe_attributes
		end
		respond_with weeks_meals
	end
end