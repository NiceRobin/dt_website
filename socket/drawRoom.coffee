shortid         = require 'shortid'

clientsCount = 0

module.exports = (io) ->

    io.on 'connection', (socket) ->
        clientsCount++

        mongo.draw.find {room: '1'}, (err, docs) ->
            initData = {}
            initData.id = shortid.generate()
            initData.room = '1'
            initData.image = docs[0].data if docs.length > 0
            socket.emit 'drawInit', initData
        
        socket.on 'disconnect',  ->
            clientsCount--

        socket.on 'drawClick', (data) -> 
            socket.broadcast.emit 'draw', data
        
        