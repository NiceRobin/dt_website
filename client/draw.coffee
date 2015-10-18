app = 
    queue: {}
    dirty: false
    ready: false
    option: 
        line:   1
        color:  '#000000'

init = ->
    box = $ '.canvas-box'

    width = 1000
    height = 700

    box.css 'height', height + ''
    box.css 'width', width + ''

    canvas = document.getElementById 'mainCanvas'
    canvas.width = width
    canvas.height = height
    app.ctx = canvas.getContext '2d'
    app.ctx.lineCap = 'round'
    return

save = ->
    return unless app.dirty is true
    canvas = app.ctx.canvas
    data = canvas.toDataURL()
    $.post '/draw/save', {data: data, room: app.room}
    app.dirty = false

getDrawPoint = (e) ->
    offset = app.canvas.offset()
    x = e.pageX - offset.left
    y = e.pageY - offset.top
    { x: x, y: y }

redraw = ->
    return unless app.ready is true
    for clientID, info of app.queue
        continue unless info?
        actArr = info.act
        option = info.opt
        for i in [0...actArr.length]
            app.ctx.beginPath()
            action = actArr[i]
            last = actArr[i - 1]
            if action.type is 1 and i isnt 0
                app.ctx.moveTo last.x, last.y
            else
                app.ctx.moveTo action.x, action.y
            app.ctx.lineTo action.x, action.y
            app.ctx.closePath()
            app.ctx.lineWidth = option.line
            app.ctx.strokeStyle = option.color
            app.ctx.stroke()
    return

drawStart = (e) ->
    app.drawing = true
    app.dirty = true
    action = getDrawPoint(e)
    action.type = 0
    actArr = []
    app.queue[app.clientID] = { act: actArr, opt: app.option }
    actArr.push action
    redraw()
    app.socket.emit 'drawClick', {id: app.clientID, act: action, opt: app.option}

draw = (e) ->
    return unless app.drawing is true
    action = getDrawPoint(e)
    action.type = 1
    app.queue[app.clientID].act.push action
    redraw()
    app.socket.emit 'drawClick', {id: app.clientID, act: action, opt: app.option}

drawEnd = (e) ->
    app.drawing = false
    redraw()
    app.queue[app.clientID] = undefined
    app.socket.emit 'drawClick', {id: app.clientID, act: 'end_draw', opt: app.option}

$ ->
    host = window.location.origin
    app.socket = io.connect(host)

    app.socket.on 'draw', (data) ->
        return app.queue[data.id] = undefined if data.act is 'end_draw'

        if app.queue[data.id]?
            app.queue[data.id].act.push data.act
            app.queue[data.id].opt = data.opt
        else
            app.queue[data.id] = 
                act: [data.act]
                opt: data.opt
        redraw()

    app.socket.on 'drawInit', (data) -> 
        app.clientID = data.id
        app.room = data.room
        if data.image?
            image = new Image
            image.onload = ->
                app.ctx.drawImage image, 0, 0
                app.ready = true
            image.src = data.image
        else
            canvas = app.ctx.canvas
            width = canvas.width
            height = canvas.height
            app.ctx.rect 0, 0, width, height
            app.ctx.fillStyle = 'white'
            app.ctx.fill()
            app.ready = true

    app.canvas = $ '#mainCanvas'
    app.canvas.css 'background-color', '#FFFFFF'
    app.canvas.css 'cursor', 'default'
    app.canvas.mousedown drawStart
    app.canvas.mousemove draw
    app.canvas.mouseup drawEnd
    app.canvas.mouseleave drawEnd
    init()

    window.setInterval save, 10000

    $ '#draw-save'
    .click ->
        canvas = app.ctx.canvas
        window.open canvas.toDataURL('image/png').replace(/^data:image\/[^;]/, 'data:application/octet-stream')

    $ '.draw-brush'
    .click ->
        brush = $(this).attr('brush')
        $('.draw-brush').removeClass 'active'
        $(this).addClass 'active'
        app.option.line = Number(brush)

    $ '#draw-color'
    .css 'color', app.option.color
    
    $ '#draw-color'
    .colorpicker
        format: 'hex'
        customClass: 'colorpicker-2x'
        sliders: 
            saturation: { maxLeft: 200, maxTop: 200 }
            hue: { maxTop: 200 }
            alpha: { maxTop: 200 }
    .colorpicker 'setValue', app.option.color
    .on 'changeColor.colorpicker', (event) ->
        color = event.color.toHex()
        $('#draw-color').css 'color', color
        app.option.color = color
            


