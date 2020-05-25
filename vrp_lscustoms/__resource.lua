resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

client_scripts {
	"lib/Proxy.lua",
	"menu.lua",
	"lsconfig.lua",
	"lscustoms.lua",
	
}

server_script {
	"@vrp/lib/utils.lua",
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"lscustoms_server.lua"
}