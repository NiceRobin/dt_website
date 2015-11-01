
pages = 
    index: 
        href: '/'
        name: '首页'
        title: '~ Double Touch 动漫社的网站 ~'
    draw: 
        href: '/draw'
        name: '绘茶'
        title: '~ Double Touch 绘茶 ~'

layout = 
    render: (req, res, name, param = {}) ->
        param.pages = pages
        param.name = name
        param.title = if name is 'error' then '~ 你想要的并不存在 ~' else pages[name].title
        _id = mongojs.ObjectId(req.session.id)
        if _id?
            mongo.user.find { _id }, { nickname: 1 }, (err, docs) ->
                if not err? and docs.length is 1
                    param.nickname = docs[0].nickname
                res.render name, param
        else
            res.render name, param
        
    route: (app) ->
        app.use '/', require '../routes/index'
        app.use '/draw', require '../routes/draw'
        app.use '/gate', require '../routes/gate'

module.exports = layout