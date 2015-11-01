express     = require 'express'
router      = express.Router()

router.get '/', (req, res, next) ->
    site.pages.render req, res, 'draw'

router.post '/save', (req, res, next) ->
    data = req.body.data
    room = req.body.room
    return res.status(400).send('data undefined') unless data? and room?
    mongo.draw.update {room: room}, {$set: {data: data}}, {upsert: true}, (err, docs) ->
        if err?
            res.send(err)
        else
            res.status(200).send('saved.')

module.exports = router
