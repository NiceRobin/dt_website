bcrypt      = require 'bcrypt'
bluebird.promisifyAll bcrypt

class User
    constructor: (param) ->
        { @username, @nickname, @_id } = param

    @createNewUser: (param) ->
        bcrypt.hashAsync param.pwd, 8
        .then (pwd) ->
            param.pwd = pwd
            mongo.user.insertAsync param
            .then (doc) => new User doc

    @signin: (username, pwd) ->
        mongo.user.findAsync { username }
        .then (docs) ->
            if docs.length > 1
                throw new ServerError.Internal('duplicate user ' + JSON.stringify kv)
            else if docs.length > 0
                bcrypt.compareAsync pwd, docs[0].pwd
                .then (match) ->
                    throw new ServerError.Basic 'pwd_wrong' if match is false
                    new User(docs[0])
            else
                throw new ServerError.Basic 'no_user'

    @findByUsername: (username) ->
        User._findByUniqueKey { username }

    @findByNickName: (nickname) ->
        User._findByUniqueKey { nickname }

    @findById: (id) ->
        _id = mongojs.ObjectId(id)
        User._findByUniqueKey { _id }

    @_findByUniqueKey: (kv) ->
        mongo.user.findAsync kv
        .then (docs) ->
            if docs.length > 1
                throw new ServerError.Internal('duplicate user ' + JSON.stringify kv)
            else if docs.length > 0
                new User docs[0]

module.exports = User
