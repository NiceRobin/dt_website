class Topic
    constructor: (@owner) ->
        @content = []
        @tags = []

    setContent: (index, msg) ->
        @content[index] = msg
        @update()

    update: ->
        @updateTime = new Date()

module.exports = Topic
