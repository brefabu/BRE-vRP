
ui_page('html/UI.html') --THIS IS IMPORTENT


dependency "vrp"

client_scripts{ 
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}


--[[The following is for the files which are need for you UI (like, pictures, the HTML file, css and so on) ]]--
files {
	'html/UI.html',
  'html/style.css',
  'html/media/font/Bariol_Regular.otf',
  'html/media/font/Vision-Black.otf',
  'html/media/font/Vision-Bold.otf',
  'html/media/font/Vision-Heavy.otf',
  'html/media/img/bg.png',
  'html/media/img/circle.png',
  'html/media/img/curve.png',
  'html/media/img/fingerprint.png',
  'html/media/img/fingerprint.jpg',
  'html/media/img/graph.png',
  'html/media/img/logo-big.png',
  'html/media/img/logo-top.png'
}
