global.dlog     = require('debug')('dt')
global.config   = require('./misc/config')
global.mongojs  = require 'mongojs'
global.mongo    = require('./misc/mongo')()
global.utils    = require './misc/utils'
global.site     = require './controller/site'
