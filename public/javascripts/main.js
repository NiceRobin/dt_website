$(function(){
    $('#post').on('click', function(e){
        param = { message: $('#message').val() };
        $('#message').val('')
        $.get('/post_msg', param, function(data) {
            console.log(data)
            $('#result').html(data)
        });
    });
});