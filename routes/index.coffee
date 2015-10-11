express     = require 'express'
router      = express.Router()

cache = []

router.get '/', (req, res, next) ->
    param = 
        title: "~ Double Touch 动漫社的网站 ~"
        message: cache

    res.render 'index', param

router.get '/post_msg', (req, res, next) ->
    message = req.query.message.toString()
    time = new Date()
    months = time.getMonth() + 1
    day = time.getDate()
    hour = time.getHours()
    min = time.getMinutes()
    timeStr = "#{months}/#{day} #{hour}:#{min}"

    cache.unshift() timeStr  + ": " + message.substring(0, 500) if message? and message isnt ""
    cache.pop() if cache.length > 100

    html = ""
    html += "<li class=\"list-group-item\">#{msg}</li>" for msg in cache
    res.send(html)

module.exports = router
