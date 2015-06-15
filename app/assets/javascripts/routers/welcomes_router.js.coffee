class Forage.Routers.Welcomes extends Backbone.Router
  routes:
    '': 'welcome'
  
  initialize: ->
    @ingredients = new Forage.Collections.Ingredients
  
  welcome: ->
    welcome = new Forage.Views.WelcomesIndex(ingredients: @ingredients)
    $('#welcome').html(welcome.render().el)
    #$('.sortable').sortable()
    $('#crossover_slider').slider
      min: 0
      max: 100
      step: 10
      slide: (event, ui) ->
        $("#crossover_slider_label").html (ui.value+"%")
    $('.ui-slider-handle').css("background":"#879767", "border-color":"#BED293")
    $("#crossover_slider_label").html ("0%")