window.dt_addInputError = (name, feedback) ->
    $("#{name}-feedback").text(feedback)
    $("#{name}-feedback").parent().addClass('has-error')

window.dt_removeInputError = (name) ->
    $("#{name}-feedback").text('')
    $("#{name}-feedback").parent().removeClass('has-error')

window.dt_strongPwd = (pwd) ->
    CryptoJS.SHA256("!e2S3$idi" + pwd + "#Xiw*^fj2").toString()
