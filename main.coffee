express         = require 'express'
path            = require 'path'
favicon         = require 'serve-favicon'
logger          = require 'morgan'
cookieParser    = require 'cookie-parser'
bodyParser      = require 'body-parser'
http            = require 'http'

routes          = require './routes/index'
users           = require './routes/users'

debug           = require('debug')('dt_website:server')

app = express()

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

app.use favicon(path.join(__dirname, 'public', 'icon/favicon.ico'))
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes
app.use '/users', users


app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next(err)

if app.get 'env' is 'development'
    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render 'error', 
            message: err.message
            error: err

app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error', 
        message: err.message
        error: {}

app.listen '3000'
