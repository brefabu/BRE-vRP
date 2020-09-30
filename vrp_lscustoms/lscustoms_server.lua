local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_LSCustoms")

local tbl = {
[1] = {locked = false, player = nil},
[2] = {locked = false, player = nil},
[3] = {locked = false, player = nil},
[4] = {locked = false, player = nil},
[5] = {locked = false, player = nil},
[6] = {locked = false, player = nil},
}
RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	local mymoney = 999999 --Just so you can buy everything while there is no money system implemented
	if button.price then -- check if button have price
		if button.price <= mymoney then
			TriggerClientEvent("LSC:buttonSelected", source,name, button, true)
			mymoney  = mymoney - button.price
		else
			TriggerClientEvent("LSC:buttonSelected", source,name, button, false)
		end
	end
end)

RegisterServerEvent("lscustom:doPayment")
AddEventHandler("lscustom:doPayment", function(price)
	local user_id = vRP.getUserId({source})
	if vRP.tryPayment({user_id, price}) then
		TriggerClientEvent("lscustom:sayPayment",source,2)
	else
		TriggerClientEvent("lscustom:sayPayment",source,3)
	end	
end)

RegisterServerEvent("lscustom:sendDB")
AddEventHandler("lscustom:sendDB", function(upgrades, vehicle)
	local user_id = vRP.getUserId({source})

	vRP.updateUpsVehicle({vehicle,upgrades})
end)
