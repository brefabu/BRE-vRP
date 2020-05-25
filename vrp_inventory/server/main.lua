local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_inventory")

function split(str, sep)
    local array = {}
    local reg = string.format("([^%s]+)", sep)
    for mem in string.gmatch(str, reg) do
        table.insert(array, mem)
    end
    return array
end

RegisterServerEvent("vRP:openInventoryGui")
AddEventHandler("vRP:openInventoryGui",function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    local data = vRP.getInventory({"player:"..user_id})
    if data.items then
        local inventory = {}
        local weight = 0

        for data_k, data_v in pairs(data.items) do
            print(data_k,data_v)
            local item_name = vRP.getItemName({data_k})
            if item_name then
                table.insert(inventory,{name = item_name, amount = data_v,idname = tostring(data_k)})
            end
            weight = weight + data_v*vRP.getItemWeight({data_k})
        end
        TriggerClientEvent("vRP:updateInventory", source, inventory, weight, 30)
    end
end)

RegisterServerEvent("vRP:useItem")
AddEventHandler("vRP:useItem",function(data)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    if vRP.tryGetInventoryItem({"player:"..user_id, tostring(data.idname), parseInt(data.amount)}) then
        vRP.playerUseItem({user_id,tostring(data.idname)})
    end
end)

RegisterServerEvent("vRP:dropItem")
AddEventHandler("vRP:dropItem",function(data)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRP.tryGetInventoryItem({"player:"..user_id, tostring(data.idname), parseInt(data.amount)})
end)


RegisterServerEvent("vRP:giveItem")
AddEventHandler("vRP:giveItem",function(data)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    local amount = parseInt(data.amount)
                    local new_weight = vRP.getInventoryWeight({"player:"..nuser_id}) + vRP.getItemWeight({tostring(data.idname)}) * amount
                    if new_weight <= vRP.getInventoryMaxWeight({"player:"..nuser_id}) then
                        if vRP.tryGetInventoryItem({"player:"..user_id, tostring(data.idname), amount}) then
                            vRP.giveInventoryItem({"player:"..nuser_id, tostring(data.idname), amount})
                            vRPclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                            vRPclient.playAnim(nplayer, {true, {{"mp_common", "givetake2_a", 1}}, false})
                        else
                            vRPclient.notify(player, {"~r~EROARE!"})
                        end
                    else
                        vRPclient.notify(player, {"~r~Nu are loc in inventar!"})
                    end
                else
                    vRPclient.notify(player, {"~r~Niciun jucator in apropiere!"})
                end
            else
                vRPclient.notify(player, {"~r~Niciun jucator in apropiere!"})
            end
        end)
    end
end)
