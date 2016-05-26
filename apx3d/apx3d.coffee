
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


getShader = (gl, str, type) ->
    shader = gl.createShader type
    gl.shaderSource shader, str
    gl.compileShader shader
    if gl.getShaderParameter(shader, gl.COMPILE_STATUS)
        return shader
    else
        console.log gl.getShaderInfoLog(shader)

start = ->
    gl = initGL()
    list = []
    list.push "/shader/basic.vsh"
    list.push "/shader/basic.fsh"
    loader.load list, (result) ->
        vsh = getShader gl, result["/shader/basic.vsh"], gl.VERTEX_SHADER
        fsh = getShader gl, result["/shader/basic.fsh"], gl.FRAGMENT_SHADER
        program = gl.createProgram()
        gl.attachShader program, vsh
        gl.attachShader program, fsh
        gl.linkProgram program
        if not gl.getProgramParameter(program, gl.LINK_STATUS)
            return console.log "link program error"
        
        gl.useProgram program
        program.attribute_location_position = gl.getAttribLocation program, "position"
        gl.enableVertexAttribArray program.attribute_location_position
        program.uniform_location_mvp = gl.getUniformLocation program, "mvp"

        buffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
        vertices = [
             0.0,  1.0,  -10.0,
            -1.0, -1.0,  -10.0,
             1.0, -1.0,  -10.0
        ]
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)
        buffer.size = buffer.count = 3

        gl.clearColor 0, 0, 0, 1
        gl.enable gl.DEPTH_TEST
        gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight
        gl.clear gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT

        matp = matrix4.makePerspectiveProjection 45, gl.viewportWidth / gl.viewportHeight, 0.1, 1000

        gl.bindBuffer gl.ARRAY_BUFFER, buffer
        gl.vertexAttribPointer program.attribute_location_position, buffer.size, gl.FLOAT, false, 0, 0
        gl.uniformMatrix4fv program.uniform_location_mvp, false, matp.mat
        gl.drawArrays gl.TRIANGLE_STRIP, 0, buffer.count

start()
