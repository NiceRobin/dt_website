global.dlog         = require('debug') 'dt'
global.__           = require 'lodash'
global.config       = require './misc/config'
global.ServerError  = require './misc/error'

global.bluebird     = require 'bluebird'

global.mongojs      = require 'mongojs'
global.mongo        = require('./misc/mongo')()

global.utils        = require './misc/utils'
global.site         = require './controller/site'





# test = ->
#     bluebird.delay 2000
#             .then ->
#                 throw new Error()


# test()
# .then (result) ->
#     dlog result
# .catch ->
#     dlog "catch error"


# bluebird
# .delay 1000
# .then ->
#     bluebird
#     .delay 1000
#     .then -> throw new Error("11")
# .catch ->
#     dlog 'yoo'
