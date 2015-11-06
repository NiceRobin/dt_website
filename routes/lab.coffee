express     = require 'express'
router      = express.Router()

router.get '/', (req, res, next) ->
    res.render 'lab'



module.exports = router