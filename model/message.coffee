class Message
    constructor: (@owner, @content) ->
        @_update()

    _update: ->
        @updateTime = new Date()

module.exports = Message
