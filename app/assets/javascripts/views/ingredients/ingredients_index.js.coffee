class Forage.Views.IngredientsIndex extends Backbone.View

  template: JST['ingredients/index']
  
  render: ->
    $(@el).html(@template(ingredients: @ingredients))
    this
  
  initialize: (attr) ->
    @ingredients = attr.ingredients