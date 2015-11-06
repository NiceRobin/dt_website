class Message
    constructor: (@owner, @content) ->
        @update()

    update: ->
        @updateTime = new Date()

module.exports = Message
