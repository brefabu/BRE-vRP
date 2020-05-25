local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_rent")

RegisterServerEvent('vRP_rent: payment')
AddEventHandler('vRP_rent: payment', function(vehicle,price)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	
	if vRP.tryPayment({user_id,price}) then
		TriggerClientEvent('vRP_Rent: spawncar', player, vehicle)
		vRPclient.notify(player,{"Ai inchiriat un vehicul!"})
	else
		vRPclient.notify(player,{"~r~Nu ai destui bani!"})
	end
end)
