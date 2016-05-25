
matrix = require './matrix'

initGL = ->
    canvas = document.getElementById "apx3dCanvas"
    try
        canvas.width = 1000
        canvas.height = 700
        gl = canvas.getContext 'webgl'
        gl.viewportWidth = canvas.width
        gl.viewportHeight = canvas.height
    catch error
        alert "Could not initialise WebGL (#{error}), sorry :-("
    gl


start = ->
    gl = initGL()
    gl.clearColor 0, 0, 0, 1
    gl.enable gl.DEPTH_TEST
    gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight
    gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

start()
