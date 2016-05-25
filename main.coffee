express         = require 'express'
path            = require 'path'
favicon         = require 'serve-favicon'
cookieParser    = require 'cookie-parser'
bodyParser      = require 'body-parser'
http            = require 'http'
sessions        = require 'client-sessions'

app             = express()
server          = require('http').createServer(app)
io              = require('socket.io')(server)
drawRoom        = require './socket/drawRoom'
drawRoom(io)

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

cookieName = "session"
secret = config.session_secret
cookie = { ephemeral: true }
app.use sessions { cookieName, secret, cookie }

app.use favicon(path.join(__dirname, 'public', 'icon/favicon.ico'))

app.use bodyParser.json( limit: '5mb')
app.use bodyParser.urlencoded(extended: false, limit: '5mb')
app.use bodyParser.json()

app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))

site.pages.route app

app.use '/lab', require './routes/lab'

app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next(err)

app.use (err, req, res, next) ->
    res.status = err.status or 500
    dlog req.url, req.body, err if res.status isnt 404
    site.pages.render req, res, 'error', { message: "< #{res.status} >" }

server.listen config.port, ->
    dlog 'hello dt server'

