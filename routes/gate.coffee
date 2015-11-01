express     = require 'express'
router      = express.Router()
bcrypt      = require 'bcrypt'

router.post '/signout', (req, res, next) ->
    req.session.reset()
    res.send { error: 'none' }

router.post '/signup', (req, res, next) ->
    info = req.body
    username = info.username
    nickname = info.nickname
    req.session.reset()
    toolong = []
    toolong.push 'username' if username.length > 30
    toolong.push 'nickname' if nickname.length > 15
    return res.send { error: 'toolong', fields: toolong } if toolong.length > 0

    mongo.user.find { username }, (err, docs) ->
        return next(new Error(err)) if err?

        duplicate = []
        duplicate.push 'username' if docs.length > 0

        mongo.user.find {nickname}, (err, docs) ->
            return next(new Error(err)) if err?

            duplicate.push 'nickname' if docs.length > 0
            return res.send { error: 'duplicate', fields: duplicate } if duplicate.length > 0

            bcrypt.hash info.pwd, 8, (err, pwd) ->
                return next(new Error(err)) if err?

                mongo.user.insert {username, pwd, nickname}, (err, docs) ->
                    return next(new Error(err)) if err?
                    req.session.id = docs._id
                    if info.longSession is 'true'
                        req.session.setDuration utils.dayToMillisecond(config.session_max_age), false
                    res.send { error: 'none' }


router.post '/signin', (req, res, next) ->
    info = req.body
    username = info.username
    req.session.reset()
    mongo.user.find { username }, { pwd: 1 }, (err, docs) ->
        return next(new Error(err)) if err?
        return next(new Error('duplicate user')) if docs.length > 1
        return res.send { error: 'no_user' } if docs.length <= 0

        bcrypt.compare info.pwd, docs[0].pwd, (err, match) ->
            return next(new Error(err)) if err?
            return res.send { error: 'pwd_wrong' } if match is false
            req.session.id = docs[0]._id
            if info.longSession is 'true'
                req.session.setDuration utils.dayToMillisecond(config.session_max_age), false
            res.send { error: 'none' }

module.exports = router
