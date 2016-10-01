my_color = ""
my_uuid = ""
actions = {}

intervalID = ""
timeoutID = ""
count_down = ()->
  sec = $('.timer').text() - 1
  $('.timer').text sec
  if 0 == sec
    clearInterval intervalID
    $('.timer-unit').hide()

start_animation = ()->
  $('.start').transition({ display: 'block', scale: 100 }, 0)
  .transition({ scale: 1 }, 250, 'snap')
  .transition({ opacity: 0 }, 1000, 'ease')

App.battle = App.cable.subscriptions.create "BattleChannel",
  connected: ->
    @perform 'join'

  disconnected: ->

  received: (data) ->
    console.log data
    actions[data.action](data, this)

  attack: (position) ->
    ink_type = Math.floor( Math.random() * 12) + 1
    @perform 'attack', position: position, color: my_color, ink_type: ink_type

  start: () ->
    @perform 'start'


actions['join'] = (data)->
  $('.waiting').hide()
  my_color = data.color
  my_uuid = data.uuid
  $('.uuid').text(data.uuid)
  $('.color').addClass(my_color)
  my_avatar = $('#avatar-' + data.avatar).clone()
  my_avatar.attr('id', '')
  my_avatar.css('position', 'absolute')
  my_avatar.css('top', 20)
  my_avatar.css('left', 20)
  my_avatar.css('display', 'block')
  $('body').append my_avatar

actions['users'] = (data)->
  $('.users dl').empty()
  Object.keys(data.users).forEach ((key) ->
    val = @[key]
    if (my_uuid != val.uuid)
      icon = $('<dt>')
      opponent_avatar = $('#avatar-' + val.avatar).clone()
      opponent_avatar.attr('id', '')
      opponent_avatar.css('display', 'block')
      icon.append opponent_avatar

      color = $('<dd>')
      color.addClass(val.color)
      opponent_color = $('#color').clone()
      opponent_color.attr('id', '')
      color.append opponent_color

      color.append val.uuid

      $('.users dl').append icon
      $('.users dl').append color
    return
  ), data.users

actions['start'] = (data)->
  $('.attack-log').remove()
  start_animation()
  $('.timer').text 10
  clearTimeout intervalID if intervalID
  intervalID = setInterval count_down, 1000
  clearTimeout timeoutID if timeoutID
  timeoutID = setTimeout game_finish, 10000


actions['waiting'] = (data)->
  $('.waiting').show()

actions['dequeue'] = (data, that)->
  that.perform 'join'

actions['attack'] = (data)->
  attack_point = $('#ink-' + data.ink_type).clone()
  attack_point.attr('id', '')
  attack_point.css('position', 'absolute')
  attack_point.css('top', data.position.y - 250)
  attack_point.css('left', data.position.x - 250)
  attack_point.css('width', '500px')
  attack_point.css('height', '500px')
  attack_point.css('display', 'block')
  attack_point.addClass(data.color)
  attack_point.addClass('attack-log')
  $('body').append attack_point
  attack_point.transition({ scale: 0.02 }, 200, 'snap')
    .transition({ background: 'none' }, 0)
    .transition({ scale: data.scale }, 200, 'ease')
    .transition({ y: 15 }, 2000, 'ease')