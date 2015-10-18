mongojs = require 'mongojs'

module.exports = ->
    mongo = mongojs(config.mongo.db, config.mongo.collections)

    # mongo.draw.save {time: 20, name: 'nicerobin'}, (err, res) ->
    #     console.log res

    mongo