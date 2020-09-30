--Settings--
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_carwash")

RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function(dirt)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if parseFloat(dirt) > parseFloat(1.0) then
	  if vRP.tryPayment({user_id,50}) then
		vRPclient.notify(player,{"You paid 50 EURO."})
	  else
		vRPclient.notify(player,{"You're poor ^^"})
	  end	
	else
		vRPclient.notify(player,{"Already clean, maan."})
	end
end)
