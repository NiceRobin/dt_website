
cache = {}

module.exports = 
    load: (urls, callback) ->
        result = {}
        count = 0
        for url in urls
            result[url] = cache[url]
            if result[url]
                count++
                callback(result) if count is urls.length
                continue
            do (url)->
                $.ajax
                    url: url
                    success: (res) ->
                        count++
                        result[url] = cache[url] = res
                        callback(result) if count is urls.length
        return
                
    cache: -> cache