class PdfReportController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
	def to_frac(string)
		unless string.nil?
			numerator, denominator = string.split('/').map(&:to_f)
			denominator ||= 1
			return numerator/denominator
		else
			return 0
		end
	end
  
  def index
    @grocery_list = JSON.parse(params['grocery_list'])
	@ingredients_consolidated = Hash.new {|h,k| h[k] = Hash.new{|h2,k2| h2[k2] = 0}}
	@grocery_list.each do |meal|
		meal["ingredients"].each do |ingredient|
			metric_unknown = FALSE
			# convert amounts to teaspoons
			if ["teaspoon","teaspoons"].include? ingredient["ingredient_metric"]
				amount = to_frac(ingredient["ingredient_amount"])
			elsif ["tablespoon","tablespoons"].include? ingredient["ingredient_metric"]
				amount = to_frac(ingredient["ingredient_amount"]) * 3
			elsif ["cup","cups"].include? ingredient["ingredient_metric"]
				amount = to_frac(ingredient["ingredient_amount"]) * 48
			elsif ["quart","quarts"].include? ingredient["ingredient_metric"]
				amount = to_frac(ingredient["ingredient_amount"]) * 192
			else
				metric_unknown = TRUE
				amount = to_frac(ingredient["ingredient_amount"])
			end
			if metric_unknown
				@ingredients_consolidated["#{ingredient["ingredient_name"]}"][ingredient["ingredient_metric"]] = @ingredients_consolidated["#{ingredient["ingredient_name"]}"][ingredient["ingredient_metric"]] + amount
			else
				@ingredients_consolidated["#{ingredient["ingredient_name"]}"]["teaspoons"] = @ingredients_consolidated["#{ingredient["ingredient_name"]}"]["teaspoons"] + amount
			end
		end
	end
  end
end
