class ServerError

class Basic extends ServerError
    constructor: (@message, @data) ->

    handle: (req, res) ->
        res.send error: @message, data: @data

class Internal extends ServerError
    constructor: (@message) ->

    handle: ->
        dlog "Internal Error: " + @message

isServerError = (err) ->
    err instanceof ServerError

module.exports = { Basic, Internal, isServerError }
