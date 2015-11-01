express     = require 'express'
router      = express.Router()
cache = []

router.get '/', (req, res, next) ->
    site.pages.render req, res, 'index', { message: cache }

router.post '/post_msg', (req, res, next) ->
    message = req.body.message.toString()
    time = new Date()
    months = time.getMonth() + 1
    day = time.getDate()
    hour = time.getHours()
    min = time.getMinutes()
    timeStr = "#{months}/#{day} #{hour}:#{min}"

    cache.unshift timeStr  + ": " + message.substring(0, 500) if message? and message isnt ""
    cache.pop() if cache.length > 100

    html = ""
    html += "<li class=\"list-group-item\">#{msg}</li>" for msg in cache
    res.send(html)

module.exports = router
