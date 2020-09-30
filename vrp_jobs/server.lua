local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_Jobs")

RegisterServerEvent("vRP:getSalary")
AddEventHandler("vRP:getSalary",function(money)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRP.giveMoney({user_id,money})
    vRPclient.notifyPicture(player, {"CHAR_BANK_MAZE", 9, "BCR Bank", false, "Ti-ai primit salariul: ~g~"..money.." Euro~w~."})
end)

RegisterServerEvent("vRP:giveItem")
AddEventHandler("vRP:giveItem",function(item,amount)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRP.giveInventoryItem({"player:"..user_id,item,amount})
end)

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
      local choices = {}
      
      choices["Anuleaza jobul"] = {function(player,data)
        vRPclient.StopJob(player,{})
        vRPclient.removeJobBlips(player,{})
      end}

      add(choices)
    end
  end})
