express     = require 'express'
router      = express.Router()

cache = []

router.get '/', (req, res, next) ->
    param = 
        title: "~ Double Touch 动漫社的网站 ~"
        message: cache

    res.render 'index', param

router.get '/post_msg', (req, res, next) ->
    message = req.query.message
    cache.push message if message? and message isnt ""
    cache.shift() if cache.length > 5

    html = ""
    html += "<li class=\"list-group-item\">#{msg}</li>" for msg in cache
    res.send(html)

module.exports = router
