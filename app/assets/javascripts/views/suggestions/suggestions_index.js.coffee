class Forage.Views.SuggestionsIndex extends Backbone.View

  template: JST['suggestions/index']
  
  render: ->
    $(@el).html(@template(suggestions: @suggestions))
    this
  
  initialize: (attr) ->
    @suggestions = attr.suggestions