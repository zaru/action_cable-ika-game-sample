App.battle = App.cable.subscriptions.create "BattleChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log data
    attack_point = $('<div>')
    attack_point.css('position', 'absolute')
    attack_point.css('top', data.battle.position.y)
    attack_point.css('left', data.battle.position.x)
    attack_point.css('width', '1px')
    attack_point.css('height', '1px')
    attack_point.css('background', '#f00')
    $('body').append attack_point

  attack: (position) ->
    @perform 'attack', position: position
