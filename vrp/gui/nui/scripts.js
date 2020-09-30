function LoginTry() {
    var username = $("#username").val();
    var password = $("#pass").val();
    $.post("http://bre_login/LoginTry", JSON.stringify({username: username,password: password}));
    setTimeout(function(){},5000);
}

function RegisterTry() {
    var username = $("#username").val();
    var password = $("#pass").val();
    $.post("http://bre_login/RegisterTry", JSON.stringify({username: username,password: password}));
    setTimeout(function(){},5000);
}

$(document).ready(function(){
    window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.close == true ) $(".login").hide();
    });
})