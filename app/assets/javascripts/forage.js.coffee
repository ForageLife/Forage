window.Forage =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new Forage.Routers.Welcomes()
    Backbone.history.start({pushState: true})

$(document).ready ->
  Forage.initialize()
