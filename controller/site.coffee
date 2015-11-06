site = {}

site.pages          = require './pages'
site.errorHandler   = require './errorHandler'

site.Message        = require '../model/message'
site.User           = require '../model/user'
site.Topic          = require '../model/topic'

module.exports = site
