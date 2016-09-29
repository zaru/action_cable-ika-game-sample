App.battle = App.cable.subscriptions.create "BattleChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    attack_point = $('#orange-1').clone()
    attack_point.css('position', 'absolute')
    attack_point.css('top', data.battle.position.y - 25)
    attack_point.css('left', data.battle.position.x - 25)
    attack_point.css('width', '50px')
    attack_point.css('height', '50px')
    attack_point.css('display', 'block')
    $('body').append attack_point
    attack_point.transition({ scale: 2.4 }, 250, 'snap')
      .transition({ scale: 2 }, 200, 'ease')

  attack: (position) ->
    @perform 'attack', position: position
