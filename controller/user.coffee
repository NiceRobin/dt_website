user = 
    findById: (id) ->
        _id = mongojs.ObjectId(id)
        mongo.user.findAsync { _id }
        .then (docs) ->
            return docs[0] if docs.length is 1


module.exports = user