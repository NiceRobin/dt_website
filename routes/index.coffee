express     = require 'express'
router      = express.Router()

cache = []

mongo.msg.find { type: 'index' }, (err, docs) ->
    return if err?
    if docs.length > 0
        cache = docs[0].cache
    else
        mongo.msg.insert { type: 'index', cache }


router.get '/', (req, res, next) ->
    site.pages.render req, res, 'index', { message: cache }

router.post '/post_msg', (req, res, next) ->
    message = req.body.message.toString()
    time = new Date()
    months = time.getMonth() + 1
    day = time.getDate()

    nickname = req.session.nickname or "???"

    timeStr = "#{months}/#{day} #{nickname}: "

    cache.unshift timeStr + message.substring(0, 500) if message? and message isnt ""
    cache.pop() if cache.length > 200

    mongo.msg.update { type: 'index' }, { $set: { cache } }

    html = ""
    html += "<li class=\"list-group-item\">#{msg}</li>" for msg in cache
    res.send(html)

module.exports = router
