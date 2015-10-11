express     = require 'express'
router      = express.Router()


router.get '/', (req, res, next) ->
    res.render 'index', title: "d-touch's web site"

module.exports = router
