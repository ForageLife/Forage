class Forage.Views.WelcomesIndex extends Backbone.View

  template: JST['welcomes/index']
  
  render: ->
    $(@el).html(@template())
    this
  
  initialize: (attr) ->
    @ingredients = attr.ingredients
  
  events:
    "keyup #add_ingredient_field": "keyup_event"
    "click .suggestion": "add_ingredient2"
    "click .red_x": "remove_ingredient"
    "click #forage_button": "forage"
    "click #grocery_list": "grocery_list"
    "click #minimize_ingredients": "minimize_ingredients"
  
  keyup_event: (e) ->
    if $(e.currentTarget).val().length > 0
      $.ajax
        url: '/suggestion'
        type: 'GET'
        data:
          characters:  $(e.currentTarget).val()
        complete: (data) ->
          suggestions = JSON.parse(data.responseText)
          suggestions_view = new Forage.Views.SuggestionsIndex(suggestions:suggestions)
          $('#suggestions').html(suggestions_view.render().el)
        dataType: "json"
    else
      suggestions_view = new Forage.Views.SuggestionsIndex(suggestions:[])
      $('#suggestions').html(suggestions_view.render().el)
  
  add_ingredient2: (e) ->
    name = $(e.currentTarget)[0].innerText
    not_there = @ingredients.where({name: name}).length == 0
    if not_there
      @ingredients.add({name: name})
      ingredients_view = new Forage.Views.IngredientsIndex(ingredients: @ingredients)
      $('#ingredients').html(ingredients_view.render().el)
  
  remove_ingredient: (e) ->
    name = $(e.currentTarget).data("name")
    @ingredients.remove(@ingredients.where({name: name}))
    ingredients_view = new Forage.Views.IngredientsIndex(ingredients: @ingredients)
    $('#ingredients').html(ingredients_view.render().el)
  
  get_name = (model) ->
    model.get("name")
  
  forage: ->
    that = @
    $.ajax
      url: '/meal'
      type: 'GET'
      data:
        ingredients: @ingredients.models.map(get_name)
        crossover_slider: $('#crossover_slider').slider("option", "value")
        vegetarian: $('#vegetarian').is(':checked')
        vegan: $('#vegan').is(':checked')
        dairy_free: $('#dairy_free').is(':checked')
        gluten_free: $('#gluten_free').is(':checked')
        nut_free: $('#nut_free').is(':checked')
      complete: (data) ->
        that.meals = JSON.parse(data.responseText)
        meals_view = new Forage.Views.MealsIndex(meals: that.meals)
        $('#meals').html(meals_view.render().el)
      dataType: "json"
  
  grocery_list: ->
    form = document.createElement('form')
    form.action = 'pdf_report.pdf'
    form.method = 'POST'
    form.target = '_blank'
    input = document.createElement('textarea')
    input.name = 'grocery_list'
    input.value = JSON.stringify(@meals)
    form.appendChild input
    form.style.display = 'none'
    document.body.appendChild form
    form.submit()

  minimize_ingredients: ->
    $("#minimize_ingredients").toggleClass('btn-plus')
    $("#ingredient_content").slideToggle()