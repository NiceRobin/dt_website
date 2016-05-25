express     = require 'express'
router      = express.Router()

router.get '/', (req, res, next) ->
    site.pages.render req, res, 'lab'

module.exports = router