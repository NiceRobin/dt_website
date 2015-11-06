
module.exports = (app) ->
    app.use (req, res, next) ->
        err = new Error()
        err.status = 404
        next(err)

    app.use (err, req, res, next) ->
        if err instanceof ServerError.Basic
            err.handle req, res
        else
            dlog err
            res.status = err.status or 500
            site.pages.render req, res, 'error', { message: "#{res.status}" }

