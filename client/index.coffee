$ ->
    $('#chat-post').on 'click', (e) ->
        message = $('#chat-message').val()
        if message.length > 500
            $('#chat-post-form').addClass 'has-error'
            $('#chat-post').text '太长了'
        else
            param = { message }
            $('#chat-message').val ''
            $.post '/post_msg', param, (data) ->
                $('#chat-result').html(data)

    $('#chat-message').on 'input', ->
        $('#chat-post-form').removeClass 'has-error'
        $('#chat-post').text '发送'
