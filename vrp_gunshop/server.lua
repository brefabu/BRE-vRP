local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_gunshop")

RegisterServerEvent('vRP:saveWeapons')
AddEventHandler('vRP:saveWeapons', function(weapons)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	vRP.setUserWeapons({user_id,weapons})
end)

RegisterServerEvent('vRP:buyWeapon')
AddEventHandler('vRP:buyWeapon', function(class_name,weapon_name,weapon_model,weapon_price,weapon_clipSize,weapon)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	if vRP.tryPayment({user_id,tonumber(weapon_price + (weapon_price/100 * weapon_clipSize))}) then
		TriggerClientEvent("vRP:giveWeapon", player, class_name, weapon_model, weapon_clipSize, weapon)
		vRPclient.notify(player,{"Ai cumparat o arma!"})
	else
		vRPclient.notify(player,{"Nu ai destui bani!"})
	end
end)

RegisterServerEvent('vRP:buyAmmo')
AddEventHandler('vRP:buyAmmo', function(weapon_model,weapon_clipSize,weapon_price)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	if vRP.tryPayment({user_id,tonumber(weapon_price * weapon_clipSize)}) then
		TriggerClientEvent("vRP:giveAmmo", player, weapon_model, weapon_clipSize)
		vRPclient.notify(player,{"Ai cumparat munitie!"})
	else
		vRPclient.notify(player,{"Nu ai destui bani!"})
	end
end)

RegisterServerEvent('vRP:buyFullAmmo')
AddEventHandler('vRP:buyFullAmmo', function(weapon_model,weapon_price)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	if vRP.tryPayment({user_id,tonumber(weapon_price)}) then
		TriggerClientEvent("vRP:giveFullAmmo", player, weapon_model)
		vRPclient.notify(player,{"Ai cumparat o munitie completa!"})
	else
		vRPclient.notify(player,{"Nu ai destui bani!"})
	end
end)
