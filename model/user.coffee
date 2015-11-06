class User
    newUser: (@username, pwd, @nickname) ->
        mongo.user.insertAsync { @username, pwd, @nickname }
        .then (docs) => @id = docs._id

    loadUser: (doc) ->
        @username = doc.username
        @nickname = doc.nickname
        @id = doc._id ? doc.id

    @findById: (id) ->
        _id = mongojs.ObjectId(id)
        mongo.user.findAsync { _id }
        .then (docs) ->
            return docs[0] if docs.length is 1

module.exports = User
