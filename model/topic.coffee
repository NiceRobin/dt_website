class Topic
    constructor: (@owner) ->
        @content = []
        @tags = []

    setContent: (index, msg) ->
        @content[index] = msg
        @update()

    appendContent: (msg) ->
        @content.push msg

    update: ->
        @updateTime = new Date()

module.exports = Topic
