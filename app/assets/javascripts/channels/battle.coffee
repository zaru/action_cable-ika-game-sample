my_color = ""
actions = {}

App.battle = App.cable.subscriptions.create "BattleChannel",
  connected: ->
    @perform 'join'

  disconnected: ->

  received: (data) ->
    console.log data
    actions[data.action](data)

  attack: (position) ->
    ink_type = Math.floor( Math.random() * 12) + 1
    @perform 'attack', position: position, color: my_color, ink_type: ink_type


actions['join'] = (data)->
  my_color = data.color
  $('.uuid').text(data.uuid)
  $('.color').addClass(my_color)
  my_avatar = $('#avatar-' + data.avatar).clone()
  my_avatar.attr('id', '')
  my_avatar.css('position', 'absolute')
  my_avatar.css('top', 20)
  my_avatar.css('left', 20)
  my_avatar.css('display', 'block')
  $('body').append my_avatar

actions['opponent_join'] = (data)->
  console.log data

actions['waiting'] = (data)->
  $('.waiting').show()

actions['attack'] = (data)->
  attack_point = $('#ink-' + data.ink_type).clone()
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