$ ->
    $('#post').on 'click', (e) ->
        param = message: $('#message').val().substring(0, 500)
        $('#message').val ''
        $.post '/post_msg', param, (data) ->
            $('#result').html(data)


