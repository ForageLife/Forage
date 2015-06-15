pdf.fill_color "869468"
pdf.text "Grocery List", :size => 45
@ingredients_consolidated.each do |ingredient_name, metrics|
	metrics.each do |metric_name, amount|
		if metric_name == "teaspoons"
			if amount > 192
				amount = (amount / 192).round(2)
				metric_name = "quarts"
			elsif amount > 48
				amount = (amount / 48).round(2)
				metric_name = "cups"
			elsif amount > 3
				amount = (amount / 3).round(2)
				metric_name = "tablespoons"
			else
				amount = amount.round(2)
			end
		end
		i, f = amount.to_i, amount.to_f
		if i == 0
			amount = ""
		elsif i == f
			amount = i
		else
			amount = f
		end
		pdf.text "#{amount} #{metric_name} #{ingredient_name}", :size => 15
	end
end