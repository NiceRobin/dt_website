
pagesInfo =
    index:
        topPage: true
        href: '/'
        name: '首页'
        title: '猫爪与漫画'
    draw:
        topPage: true
        href: '/draw'
        name: '绘茶'
        title: '绘茶'
    new_topic:
        topPage: false
        name: '新话题'
        title: '新话题'
    error:
        topPage: false
        title: '你想要的并不存在'
pages =
    render: (req, res, name, param = {}) ->
        param.pages = pagesInfo
        param.name = name
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
        app.use '/new_topic', require '../routes/newTopic'

module.exports = pages
