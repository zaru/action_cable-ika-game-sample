my_color = ""

App.battle = App.cable.subscriptions.create "BattleChannel",
  connected: ->
    @perform 'join'

  disconnected: ->

  received: (data) ->

    if ("join" == data.action)
      my_color = data.color
    else
      attack_point = $('#ink-1').clone()
      attack_point.attr('id', '')
      attack_point.css('position', 'absolute')
      attack_point.css('top', data.position.y - 25)
      attack_point.css('left', data.position.x - 25)
      attack_point.css('width', '50px')
      attack_point.css('height', '50px')
      attack_point.css('display', 'block')
      attack_point.addClass(data.color)
      $('body').append attack_point
      attack_point.transition({ scale: 3 }, 250, 'snap')
        .transition({ scale: 2 }, 200, 'ease')

  attack: (position) ->
    @perform 'attack', position: position, color: my_color
