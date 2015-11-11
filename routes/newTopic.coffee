express     = require 'express'
router      = express.Router()

router.get '/', (req, res, next) ->
    site.pages.render req, res, 'new_topic'

module.exports = router
