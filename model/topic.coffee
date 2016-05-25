class Topic
    constructor: (@owner) ->
        @content = []
        @tags = []

    editContent: (index, msg) ->
        @content[index] = msg
        @_update()

    appendContent: (msg) ->
        @content.push msg
        @_update()

    _update: ->
        @updateTime = new Date()

    save: ->
        

module.exports = Topic
