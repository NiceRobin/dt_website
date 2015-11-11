express     = require 'express'
router      = express.Router()
bcrypt      = require 'bcrypt'

bluebird.promisifyAll bcrypt

_updateSession = (info, req) ->
    if info.longSession is 'true'
        req.session.setDuration utils.dayToMillisecond(config.session_max_age), false

router.post '/signout', (req, res, next) ->
    req.session.reset()
    res.send { error: 'none' }

router.post '/signup', (req, res, next) ->
    info = req.body
    username = info.username
    nickname = info.nickname
    req.session.reset()

    fields = []
    fields.push 'username' if username.length > 30
    fields.push 'nickname' if nickname.length > 15

    return next new ServerError.Basic 'toolong', { fields } if fields.length > 0

    mongo.user.findAsync { username }
    .then (docs) ->
        fields.push 'username' if docs.length > 0
        mongo.user.findAsync { nickname }
        .then (docs) ->
            fields.push 'nickname' if docs.length > 0
            throw new ServerError.Basic 'duplicate', { fields } if fields.length > 0

            bcrypt.hashAsync info.pwd, 8
            .then (pwd) ->
                user = new site.User()
                user.newUser username, pwd, nickname
                .then ->
                    req.session.user = user
                    _updateSession info, req
                    return res.send { error: 'none' }
    .catch next

router.post '/signin', (req, res, next) ->
    info = req.body
    username = info.username
    req.session.reset()
    mongo.user.findAsync { username }
    .then (docs) ->
        throw new ServerError.Basic 'no_user' if docs.length <= 0
        bcrypt.compareAsync info.pwd, docs[0].pwd
        .then (match) ->
            throw new ServerError.Basic 'pwd_wrong' if match is false
            user = new site.User()
            user.loadUser docs[0]
            req.session.user = user
            _updateSession info, req
            res.send { error: 'none' }
    .catch next

module.exports = router
