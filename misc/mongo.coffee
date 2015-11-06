bluebird.promisifyAll mongojs

module.exports = ->
    mongo = new mongojs(config.mongo.db, config.mongo.collections)
    mongo