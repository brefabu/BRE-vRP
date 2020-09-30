ui_page 'html/index.html'
dependency 'vrp'
files {
	'html/index.html',
	'html/design.css',
	'html/script.js',
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua'
}

client_script 'client.lua'