local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_banking")

vRPlogs = Proxy.getInterface("vRP_logs")

vRPbanking = {}
Tunnel.bindInterface("vRP_banking",vRPbanking)
Proxy.addInterface("vRP_banking",vRPbanking)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local thePlayer = source
	
	local user_id = vRP.getUserId({thePlayer})
	local walletMoney = vRP.getMoney({user_id})
	local bankMoney = vRP.getBankMoney({user_id})
	if(tonumber(amount))then
		if(vRP.tryPayment({user_id, amount}))then
			vRP.setBankMoney({user_id, bankMoney+amount})
			vRP.setMoney({user_id, walletMoney-amount})
			vRPclient.notify(thePlayer, {"~g~You put ~y~$"..amount.." ~g~!"})
		else
			vRPclient.notify(thePlayer, {"~r~Not enough in wallet!"})
		end
	else
		vRPclient.notify(thePlayer, {"~r~Invalid number!"})
	end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local thePlayer = source
	
	local user_id = vRP.getUserId({thePlayer})
	local walletMoney = vRP.getMoney({user_id})
	local bankMoney = vRP.getBankMoney({user_id})
	if(tonumber(amount))then	
		amount = tonumber(amount)
		if(amount > 0 and amount <= bankMoney)then
			vRP.setBankMoney({user_id, bankMoney-amount})
			vRP.setMoney({user_id, walletMoney+amount})
			vRPclient.notify(thePlayer, {"~g~You get ~y~$"..amount.." ~g~!"})
		else
			vRPclient.notify(thePlayer, {"~r~Not enough in bank!"})
		end
	else
		vRPclient.notify(thePlayer, {"~r~Invalid number!"})
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local thePlayer = source
	
	local user_id = vRP.getUserId({thePlayer})
	local bankMoney = vRP.getBankMoney({user_id})
	TriggerClientEvent('currentbalance1', thePlayer, bankMoney)
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amount)
	local thePlayer = source
	local user_id = vRP.getUserId({thePlayer})
	if(tonumber(to)  and to ~= "" and to ~= nil)then
		to = tonumber(to)
		theTarget = vRP.getUserSource({to})
		if(theTarget)then
			if(thePlayer == theTarget)then
				vRPclient.notify(thePlayer, {"~r~Not to you, idiot!"})
			else
				if(tonumber(amount) and tonumber(amount) > 0 and amount ~= "" and amount ~= nil)then
					amount = tonumber(amount)
					bankMoney = vRP.getBankMoney({user_id})
					if(bankMoney >= amount)then
						newBankMoney = tonumber(bankMoney - amount)
						vRP.setBankMoney({user_id, newBankMoney})
						vRP.giveBankMoney({to, amount})
						vRPclient.notify(thePlayer, {"~g~Transfered ~y~$"..amount.." ~g~ to ~b~"..vRP.getUserName({theTarget})})
						vRPclient.notify(theTarget, {"~y~"..vRP.getUserName({thePlayer}).." ~g~gived to you ~b~$"..amount})
					else
						vRPclient.notify(thePlayer, {"~r~Not enough in bank!"})
					end
				else
					vRPclient.notify(thePlayer, {"~r~Invalid number!"})
				end
			end
		else
			vRPclient.notify(thePlayer, {"~r~Id not found!"})
		end
	end
end)