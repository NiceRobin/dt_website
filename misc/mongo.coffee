module.exports = ->
    mongo = mongojs(config.mongo.db, config.mongo.collections)
    mongo