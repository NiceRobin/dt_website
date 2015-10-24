express         = require 'express'
path            = require 'path'
favicon         = require 'serve-favicon'
logger          = require 'morgan'
cookieParser    = require 'cookie-parser'
bodyParser      = require 'body-parser'
http            = require 'http'
app             = express()
server          = require('http').createServer(app)
io              = require('socket.io')(server)
drawRoom        = require './socket/drawRoom'

drawRoom(io)

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use favicon(path.join(__dirname, 'public', 'icon/favicon.ico'))
app.use logger('tiny')

app.use bodyParser.json( limit: '5mb')
app.use bodyParser.urlencoded(extended: false, limit: '5mb')
app.use bodyParser.json()

app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))

app.use '/', require './routes/index'
app.use '/draw', require './routes/draw'

app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next(err)

app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error', 
        message: err.message
        error: err

server.listen config.port, ->
    dlog 'hello dt server'

