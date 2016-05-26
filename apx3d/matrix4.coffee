utils = require './utils'

class Matrix4
    constructor: ->
        @mat = new Float32Array(16)

    @makePerspectiveProjection: (fov, aspect, zNear, zFar) ->
        r = utils.degreesToRadians fov / 2
        deltaZ = zFar - zNear
        cotangent = Math.cos(r) / Math.sin(r)
        m = new Matrix4()
        m.mat[0] = cotangent / aspect
        m.mat[5] = cotangent
        m.mat[10] = -(zFar + zNear) / deltaZ
        m.mat[11] = -1
        m.mat[14] = -2 * zNear * zFar / deltaZ
        m

    @makeTranslation: (x, y, z) ->
        m = new Matrix4()
        m.mat[0] = 1.0
        m.mat[5] = 1.0
        m.mat[10] = 1.0
        m.mat[12] = x
        m.mat[13] = y
        m.mat[14] = z
        m

    @makeScale: (x, y, z) ->
        m = new Matrix4()
        m.mat[0] = x
        m.mat[5] = y
        m.mat[10] = z
        m.mat[15] = 1.0
        m

module.exports = Matrix4