
matrix4 = require './matrix4'
loader = require './loader'

initGL = ->
    canvas = document.getElementById "apx3dCanvas"
    try
        canvas.width = 1000
        canvas.height = 700
        gl = canvas.getContext 'webgl'
        gl.viewportWidth = canvas.width
        gl.viewportHeight = canvas.height
    catch error
        console.log "Could not initialise WebGL (#{error}), sorry :-("
    gl

compileShader = (gl, str, type) ->
    shader = gl.createShader type
    gl.shaderSource shader, str
    gl.compileShader shader
    if !gl.getShaderParameter(shader, gl.COMPILE_STATUS)
        throw new Error gl.getShaderInfoLog(shader)
    shader

start = ->
    gl = initGL()
    vsh = compileShader gl, loader.cache()["/shader/basic.vsh"], gl.VERTEX_SHADER
    fsh = compileShader gl, loader.cache()["/shader/basic.fsh"], gl.FRAGMENT_SHADER
    program = gl.createProgram()
    gl.attachShader program, vsh
    gl.attachShader program, fsh
    gl.linkProgram program
    if not gl.getProgramParameter(program, gl.LINK_STATUS)
        return console.log "link program error"
    
    gl.useProgram program
    

    program.attribute_location_position = gl.getAttribLocation program, "position"
    gl.enableVertexAttribArray program.attribute_location_position

    program.attribute_location_color = gl.getAttribLocation program, "color"
    gl.enableVertexAttribArray program.attribute_location_color

    program.uniform_location_mvp = gl.getUniformLocation program, "mvp"

    buffer = gl.createBuffer()
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer)

    vertices = [
         0.0,  1.0,  -10.0,
         1.0,  0.0,    0.0,  1.0,
        -1.0, -1.0,  -10.0,
         0.0,  1.0,    0.0,  1.0,
         1.0, -1.0,  -10.0,
         0.0,  0.0,    1.0,  1.0
    ]
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)

    gl.clearColor 0, 0, 0, 1
    gl.enable gl.DEPTH_TEST
    gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight
    gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

    matp = matrix4.makePerspectiveProjection 45, gl.viewportWidth / gl.viewportHeight, 0.1, 1000

    gl.bindBuffer gl.ARRAY_BUFFER, buffer

    gl.vertexAttribPointer program.attribute_location_position, 3, gl.FLOAT, false, 28, 0
    gl.vertexAttribPointer program.attribute_location_color, 4, gl.FLOAT, false, 28, 12

    gl.uniformMatrix4fv program.uniform_location_mvp, false, matp.mat
    gl.drawArrays gl.TRIANGLE_STRIP, 0, 3

loader.load ["/shader/basic.vsh", "/shader/basic.fsh"], start





