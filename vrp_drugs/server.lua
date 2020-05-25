local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_drugs")
vRP = Proxy.getInterface("vRP")

local function Prelucreaza(player,item, timeout, request)
    local user_id = vRP.getUserId({player})

    vRP.request({player,"Doresti sa prelucrezi? ", 60, function(player,ok)
        if ok then
            local inventory = vRP.getInventory({"player:"..user_id})
            local amount = 0

            if inventory.items[request[1]] then
                amount = math.floor(inventory.items[request[1]]/request[2])
            end
            if amount > 0 then
                if vRP.tryGetInventoryItem({"player:"..user_id, request[1], request[2]}) then
                    vRPclient.notify(player,{"Ai inceput procesarea a "..amount.." bucati!"})
                    TriggerClientEvent("vRP:processDrugs", player, true)
                    SetTimeout(timeout, function()
                        vRPclient.notify(player,{"Ai terminat procesarea!"})
                        TriggerClientEvent("vRP:processDrugs", player, false)
                        vRP.giveInventoryItem({"player:"..user_id, item, amount})
                    end)
                else
                    vRPclient.notify(player,{"Nu ai toate ingredientele!"})
                end
            else
                vRPclient.notify(player,{"Nu ai toate ingredientele!"})
            end
        end
    end})
end

RegisterServerEvent("vRP:prelucruPrafuri")
AddEventHandler("vRP:prelucruPrafuri",function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRP.buildMenu({"prafuri", {player = player}, function(menu)
        menu.name = "Prafuri"
        menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
        menu.onclose = function(player) vRP.closeMenu({player}) end

        menu["LSD"] = {function(player,choice)
            Prelucreaza(user_id,"lsd",2.5*60*1000,{"harness",3})
        end,"Ingrediente: 3 harness<br><br> Dureaza 2 minute si 30 de secunde."}

        menu["Cocaina"] = {function(player,choice)
            Prelucreaza(player,"cocaina",2.5*60*1000,{"benzoilmetilecgonina",4})
        end,"Ingrediente: 4 benzo<br><br> Dureaza 2 minute si 30 de secunde."}

        menu["Heroina"] = {function(player,choice)
            Prelucreaza(user_id,"heroina",2.5*60*1000,{"opiu",5})
        end,"Ingrediente: 5 opiu<br><br> Dureaza 2 minute si 30 de secunde."}
        
        vRP.openMenu({player,menu})
    end})
end)

RegisterServerEvent("vRP:prelucruIerburi")
AddEventHandler("vRP:prelucruIerburi",function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRP.buildMenu({"ierburi", {player = player}, function(menu)
        menu.name = "Ierburi"
        menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
        menu.onclose = function(player) vRP.closeMenu({player}) end

        menu["Canabis"] = {function(player,choice)
            Prelucreaza(user_id,"canabis",2.5*60*1000,{"seeds",3})
        end,"Ingrediente: 3 seminte<br><br> Dureaza 2 minute si 30 de secunde."}
        
        vRP.openMenu({player,menu})
    end})
end)