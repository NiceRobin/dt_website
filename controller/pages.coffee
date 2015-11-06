
pagesInfo =
    index:
        href: '/'
        name: '首页'
        title: 'Double Touch 动漫社的网站'
    draw:
        href: '/draw'
        name: '绘茶'
        title: 'Double Touch 绘茶'

pages =
    render: (req, res, name, param = {}) ->
        param.pages = pagesInfo
        param.name = name
        param.title = if name is 'error' then '你想要的并不存在' else pagesInfo[name].title

        user = req.session.user
        if user?
            param.nickname = user.nickname
            res.render name, param
        else
            res.render name, param

    route: (app) ->
        app.use '/', require '../routes/index'
        app.use '/draw', require '../routes/draw'
        app.use '/gate', require '../routes/gate'

module.exports = pages
