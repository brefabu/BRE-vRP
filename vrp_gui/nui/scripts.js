$(document).ready(function(){
  $(".hud").hide();
  window.addEventListener("message", function(event){
    if(event.data.survival == true){
      $(".hud").show();
      setProgress(event.data.hunger,'.progress-hunger');
      setProgress(event.data.thirst,'.progress-thirst');
    }
    if(event.data.plys){
      $(".plys").show();
    }
    if(event.data.money){
      $(".value").html(event.data.money+" EURO");
    }
  });
});
  
  function setProgress(percent, element){
    $(element).css("width",percent+"%");
  }
  