express     = require 'express'
router      = express.Router()

User = site.User

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
    pwd = info.pwd
    req.session.reset()

    fields = []
    fields.push 'username' if username.length > 30
    fields.push 'nickname' if nickname.length > 15

    return next new ServerError.Basic 'toolong', { fields } if fields.length > 0

    User.findByUsername username
    .then (doc) ->
        fields.push 'username' if doc?
        User.findByNickName nickname
        .then (doc) ->
            fields.push 'nickname' if doc?
            throw new ServerError.Basic 'duplicate', { fields } if fields.length > 0

            User.createNewUser { username, nickname, pwd }
            .then (user) ->
                req.session.user = user
                _updateSession info, req
                return res.send { error: 'none' }
    .catch next

router.post '/signin', (req, res, next) ->
    info = req.body
    username = info.username
    pwd = info.pwd
    dlog pwd
    req.session.reset()
    User.signin username, pwd
    .then (user) ->
        req.session.user = user
        _updateSession info, req
        res.send { error: 'none' }
    .catch next

module.exports = router
