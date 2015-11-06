$ ->
    $('#gate-modal').on 'show.bs.modal', ->
        $('#gate-form input[type=text],input[type="password"]').val('')
        $('#sign-content .form-control-feedback').text('')
        $('#sign-content .form-group').removeClass('has-error')
        $('#long-session').prop 'checked', false
        $('.signup-element').hide()
        $('#signin-buttons').show()
        $('#signup-buttons').hide()

    $('#signout').on 'click', (e) ->
        $.post '/gate/signout', {}, (data) -> location.reload()

    $('#signin').on 'click', (e) ->
        username = $('#user-name').val()
        pwd = $('#pwd').val()
        longSession = $('#long-session').prop 'checked'
        pwd = dt_strongPwd pwd
        param = { username, pwd, longSession}
        $.post '/gate/signin', param, (data) ->
            return unless data?
            if data.error is 'no_user'
                dt_addInputError '#user-name', '并无此人'                    
            else if data.error is 'pwd_wrong'
                dt_addInputError '#pwd', '密码错了'
            else if data.error is 'none'
                location.reload()

    $('#signup').on 'click', (e) ->
        username = $('#user-name').val()
        pwd = $('#pwd').val()
        pwd2 = $('#confirm-pwd').val()
        nickname = $('#nickname').val()
        longSession = $('#long-session').prop 'checked'
        return dt_addInputError '#confrim-pwd', '并不一样' if pwd isnt pwd2
        pwd = dt_strongPwd pwd
        param = { username, pwd, nickname, longSession }
        $.post '/gate/signup', param, (data) ->
            return unless data?
            if data.error is 'duplicate' or data.error is 'toolong'
                text = if data.error is 'toolong' then '太长了' else '有人用了'
                if 'username' in data.data.fields
                    dt_addInputError '#user-name', text
                if 'nickname' in data.data.fields
                    dt_addInputError '#nickname', text

            else if data.error is 'none'
                location.reload()

    $('#user-name').on 'input', ->
        dt_removeInputError '#user-name'

    $('#nickname').on 'input', ->
        dt_removeInputError '#nickname'

    $('#confirm-pwd').on 'input', ->
        pwd = $('#pwd').val()
        pwd2 = $('#confirm-pwd').val()
        if pwd isnt pwd2 and pwd2 isnt ''
            dt_addInputError '#confrim-pwd', '并不一样'
        else
            dt_removeInputError '#confrim-pwd'

    $('#pwd').on 'input', ->
        pwd = $('#pwd').val()
        pwd2 = $('#confirm-pwd').val()
        if pwd isnt pwd2 and pwd2 isnt ''
            dt_addInputError '#confrim-pwd', '并不一样'
        else
            dt_removeInputError '#confrim-pwd'

    $('#show-signup').on 'click', (e) ->
        $('form#gate-form input[type=text],input[type="password"]').val('')
        $('#sign-content .form-control-feedback').text('')
        $('#sign-content .form-group').removeClass('has-error')
        $('#long-session').prop 'checked', false
        $('.signup-element').fadeIn 'fast'
        $('#signin-buttons').hide()
        $('#signup-buttons').show()

    $('#show-signin').on 'click', (e) ->
        $('form#gate-form input[type=text],input[type="password"]').val('')
        $('#sign-content .form-control-feedback').text('')
        $('#sign-content .form-group').removeClass('has-error')
        $('#long-session').prop 'checked', false
        $('.signup-element').fadeOut 'fast'
        $('#signin-buttons').show()
        $('#signup-buttons').hide()
        