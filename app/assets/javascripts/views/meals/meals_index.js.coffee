class Forage.Views.MealsIndex extends Backbone.View

  template: JST['meals/index']
  
  render: ->
    @weekdays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    $(@el).html(@template(meals: @meals, weekdays: @weekdays))
    this
  
  initialize: (attr) ->
    @meals = attr.meals