$(function(){
    $('#post').on('click', function(e){
        param = { message: $('#message').val().substring(0, 500) };
        $('#message').val('')
        $.get('/post_msg', param, function(data) {
            console.log(data)
            $('#result').html(data)
        });
    });
});