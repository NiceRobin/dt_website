class Basic
    constructor: (@message, @data) ->

    handle: (req, res) ->
        res.send error: @message, data: @data
        

module.exports = { Basic }

