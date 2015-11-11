express     = require 'express'
router      = express.Router()

router.get '/', (req, res, next) ->
    site.pages.render req, res, 'index', { message: [] }










insertChat = (req, res, message, name) ->
    time = new Date()
    months = time.getMonth() + 1
    day = time.getDate()
    hour = ("0" + time.getHours()).slice(-2)
    min = ("0" + time.getMinutes()).slice(-2)
    timeStr = "#{months}月#{day}日#{hour}:#{min}"



renderChat = (res, cache) ->
    html = ""
    html += "<li class=\"list-group-item\">#{msg}</li>" for msg in cache
    res.send(html)

counter = 0

router.post '/post_msg', (req, res, next) ->
    message = req.body.message.toString()
    return unless message.length < 500
    counter += 1
    query =
        $push : {
            message: {
                $each: ['hello' + counter]
                $position: 0
            }
        }

    mongo.chat.update { room: 1 }, query, {upsert: true}, (err, docs) ->

    # if req.session.id?
    #     _id = mongojs.ObjectId(req.session.id)
    #     mongo.user.find { _id }, { nickname: 1 }, (err, docs) ->

    # else


    # message =
    # time = new Date()
    # months = time.getMonth() + 1
    # day = time.getDate()
    # hour = time.getHours()
    # min = time.getMinutes()
    # timeStr = "#{months}/#{day} #{hour}:#{min}"

    # cache.unshift timeStr  + ": " + message.substring(0, 500) if message? and message isnt ""
    # cache.pop() if cache.length > 100


module.exports = router
