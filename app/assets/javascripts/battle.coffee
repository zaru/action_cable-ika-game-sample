playable = true

$ ->
  event = `(window.ontouchstart === undefined)? 'click' : 'touchstart'`
  $('body').on event, (e)->
    if (e.originalEvent.touches)
      position = { x: e.originalEvent.touches[0].pageX, y: e.originalEvent.touches[0].pageY }
    else
      position = { x: e.pageX, y: e.pageY }
    if playable
      App.battle.attack(position)


@game_finish = ()->
  playable = false
  canvas = convertCanvas()
  postCanvas(canvas)

convertCanvas = ()->
  canvas = $('<canvas>')
  canvas.attr 'width', $(window).width()
  canvas.attr 'height', $(window).height()
  ctx = canvas[0].getContext('2d')

  $('.attack-log').each (index, svg_div)->
    scale = $(svg_div).css('scale')
    $svg = $(svg_div).find('svg')
    $svg.find('path').css('fill')
    svgData = new XMLSerializer().serializeToString($svg[0]).replace('<path','<path style="fill:' + $svg.find('path').css('fill') + '" ')
    image = new Image
    image.src = "data:image/svg+xml;charset=utf-8;base64," + btoa(unescape(encodeURIComponent(svgData)))
    ctx.drawImage(image, $svg.offset().left, $svg.offset().top, scale * $svg.width(), scale * $svg.height())

  canvas

postCanvas = (canvas)->
  data = {}
  canvasData = canvas[0].toDataURL()
  canvasData = canvasData.replace(/^data:image\/png;base64,/, '')
  data.image = canvasData
  $.ajax
    url: '/result'
    type: 'POST'
    success: (data)->
      $('.win-color').css('background', data[0][0])
      $('.result').fadeIn()
      return
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "fail"
      return
    data: data
    dataType: 'json'

