$ ->
  $(window).click (e)->
    position = { x: e.pageX, y: e.pageY }
    App.battle.attack(position)