function LoginTry(){
  $.post("http://vrp/login", JSON.stringify({username: $("#username").val(),password: $("#pass").val()}));
  setTimeout(function(){},5000);
}

function RegisterTry(){
  $.post("http://vrp/register", JSON.stringify({username: $("#username").val(),password: $("#pass").val()}));
  setTimeout(function(){},5000);
}

window.addEventListener('message', function(event){
  var item = event.data;
  
  if(item.loginSuccesful == true) {
    $(".login").hide();
  }
});