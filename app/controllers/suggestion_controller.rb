class SuggestionController < ApplicationController
  respond_to :json
	def index
		characters = params[:characters]
		ingredients = Ingredient.where("name like ?", "#{characters}%").order(:count).reverse_order
		ingredient_names = ingredients.map {|ingredient| ingredient.name}
		respond_with ingredient_names
	end

end
