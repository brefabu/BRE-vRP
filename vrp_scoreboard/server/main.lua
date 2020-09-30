-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local connectedPlayers = {}
local slots = {}

AddEventHandler("Proxy:updateMinutes",function(user_id,source,minutes)
	connectedPlayers[user_id].hours = tostring(math.floor(vRP.getUserTimePlayed({user_id})/60)).." Ore"
	TriggerClientEvent('vrp_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

AddEventHandler("vRP:playerLoggedIn", function(player, user_id, data)
	if player ~= nil then
		connectedPlayers[user_id] = {}
		connectedPlayers[user_id].ping = GetPlayerPing(player)
		connectedPlayers[user_id].id = user_id
		connectedPlayers[user_id].name = vRP.getUserName({player})
		connectedPlayers[user_id].hours = tostring(math.floor(vRP.getUserTimePlayed({user_id})/60)).." Ore"
		local faction = vRP.getPlayerFaction({user_id})
		connectedPlayers[user_id].job = vRP.getChatFaction({faction})

		slots = vRP.getUsers({})
		TriggerClientEvent('vrp_scoreboard:updateConnectedPlayers', -1, connectedPlayers,#slots)
	end
end)

AddEventHandler("vRP:playerLeave",function(user_id, player) 
	connectedPlayers[user_id] = nil

	slots = vRP.getUsers({})
	TriggerClientEvent('vrp_scoreboard:updateConnectedPlayers', -1, connectedPlayers,#slots)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		for k,v in pairs(connectedPlayers) do
			v.ping = GetPlayerPing(vRP.getUserSource({k}))
		end
	
		TriggerClientEvent('vrp_scoreboard:updateConnectedPlayers', -1, connectedPlayers,#slots)
	end
end)
