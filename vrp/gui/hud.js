var esc = false;
var changing = false;

$(document).ready(function(){
  $(".information-box").hide();

  window.addEventListener('message', function(event){
    var item = event.data;

    if(item.action == "loggedIn") {
      $(".information-box").show();
    }
    
    if(item.money >= 0){
      $(".money-value").html(item.money + " Euro <i class='fas fa-wallet'></i>");
    }

    if(item.slots >= 0){
      $(".info-number").html(item.slots);
    }

    if(item.hunger >= 0 && item.thirst >= 0){
      $(".thirst").css("width",item.hunger+"%");
      $(".hunger").css("width",item.thirst+"%");
    }

    if(item.action == "loggedIn") {
      $(".information-box").show();
    }
    if(item.action == "hide-body") {
      $("body").hide();
    }
    if (item.action == "show-body"){
      $("body").show();
    }
  });
})

