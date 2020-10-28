var bool = false;

function SetActive() {
  bool = !bool;

  if (bool == true) 
    $(".login").removeClass("login-active");

    if (bool == false) 
	  $(".login").addClass("login-active");
};

function LoginTry(){
  $.post("http://vrp/login", JSON.stringify({username: $("#username").val(),password: $("#password").val()}));
}

function RegisterTry(){
  $.post("http://vrp/register", JSON.stringify({username: $("#username2").val(),email: $("#email").val(),password: $("#password2").val()}));
}

window.addEventListener('message', function(event){
  var item = event.data;
  
  if(item.action =="logFormFadeOut") {
    $(".login").hide();
  }
});