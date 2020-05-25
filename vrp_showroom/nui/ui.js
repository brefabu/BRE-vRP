function buyVehicle(vehicle) {
    $(".card").remove();
    $.post('http://vrp_showroom/buy', JSON.stringify({vehicle: vehicle}));
    setTimeout(function(){},5000);
}

function viewVehicle(vehicle) {
    $(".card").remove();
    $.post('http://vrp_showroom/view', JSON.stringify({vehicle: vehicle}));
    setTimeout(function(){},5000);
}

$(document).ready(function(){
    window.addEventListener( 'message', function( event ) {
        var item = event.data;
        if ( item.vehicle != null && item.name != null && item.price != null ) {
            var text1 = "<div class='check'><a onclick='viewVehicle("+'"'+item.name+'"'+")' class='view' id="+item.vehicle+"><h1 class='text'><br>Vezi vehiculul</h1></a></div>"
            var text2 = "<div class='descript'><br><p>"+item.name+"</p><p>Pret: <b>"+'"'+item.price+'"'+" RON</b></p></div><br><div class='botao'><a onclick='buyVehicle("+'"'+item.name+'"'+")' class='buy' id="+item.vehicle+"><b>Cumpara</b></a></div>"
            $(".area").append("<div class='card'>"+text1+text2+"</div>");
        }
        if ( item.showroom == true ) {
            $('.container').css('display','block');
        } else if ( item.showroom == false ) {
            $('.container').css("display","none");
        }
    });
    $("#close").click(function(){$(".card").remove();$.post('http://vrp_showroom/close', JSON.stringify({}));});
    document.onkeyup = function (data) {
        if (data.which == 8 ) {
            $(".card").remove();
            $.post('http://vrp_showroom/close', JSON.stringify({}));
        }
        if (data.which == 27 ) {
            $(".card").remove();
            $.post('http://vrp_showroom/close', JSON.stringify({}));

        }
    };
})