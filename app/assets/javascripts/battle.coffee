$ ->
  event = `(window.ontouchstart === undefined)? 'click' : 'touchstart'`
  $('body').on event, (e)->
    if (e.originalEvent.touches)
      position = { x: e.originalEvent.touches[0].pageX, y: e.originalEvent.touches[0].pageY }
    else
      position = { x: e.pageX, y: e.pageY }
    App.battle.attack(position)