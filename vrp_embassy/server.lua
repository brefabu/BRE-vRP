local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")

vRPclient = Tunnel.getInterface("vRP","vrp_embassy")

local requests = {}

RegisterServerEvent("vRP:cerere_viza")
AddEventHandler("vRP:cerere_viza",function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    local ambasadori = vRP.getUsersFaction({"Ambasada"})
    
    if #ambasadori > 0 then
        if not vRP.hasVisa({user_id}) then
            vRP.prompt({player,"Motiv cerere:","",function(player,reason)
                if reason ~= " " and reason ~= nil then
                    local data = vRP.getUserData({user_id})
                    requests[user_id] = {firstname = data.firstname,name = data.name,age = data.age,phone = data.phone,reason = reason}
                    vRPclient.notify(player,{"Ai pus cererea in vizorul unui ambasador!"})
                    vRPclient.notify(player,{"Statusul cererii se poate vedea la ~g~/statusvisa~w~!"})
                else
                    vRPclient.notify(player,{"Motiv incorect!"})
                end
            end})
        else
            vRPclient.notify(player,{"Deja detii o viza!"})
        end
    else
        vRPclient.notify(player,{"Nu este niciun membru al ambasadei online..."})
    end
end)

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    local player = data.player

    if user_id ~= nil then
        local choices = {}
        if vRP.isPlayerInFaction({user_id,"Ambasada"}) then
            choices["Cereri Vize"] = {function(player,choice)
                vRP.buildMenu({"visa_menu", {user_id = user_id, player = player}, function(menu)
                    menu.name="Cereri Vize"
                    menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}
                    
                    if #requests > 0 then
                        for i,v in pairs(requests) do
                            menu[i..":"..v.firstname.." "..v.name] = {function(player,choice)
                                vRP.buildMenu({"visa", {user_id = user_id, player = player}, function(menu)
                                    menu.name="Accepta/Refuza Viza"
                                    menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}
    
                                    menu["Accepta"] = {function(player,choice)
                                        vRPclient.notify(player,{"Ai acceptat cererea~w~!"})
                                        vRP.acceptVisa({i})
                                        vRP.closeMenu({player})	
                                        requests[i] = nil
                                    end,"Apasa pentru a accepta cererea de viza!"}
    
                                    menu["Omite"] = {function(player,choice)
                                        vRPclient.notify(player,{"Ai refuzat cererea~w~!"})
                                        vRP.refuseVisa({i})
                                        vRP.closeMenu({player})	
                                        requests[i] = nil
                                    end,"Apasa pentru a omite cererea de viza!"}
    
                                    vRP.openMenu({player,menu})
                                end}) 
                            end,"<font color='lightgreen'>ID:</font> "..(i).."<br><font color='lightgreen'>Varsta:</font> "..(v.age).."<br><font color='lightgreen'>Telefon:</font> "..(v.phone).."<br><font color='red'>Apasa pentru a gestiona cererea!</font>"}
                        end
                    else
                        vRPclient.notify(player,{"Nu exista cereri..."})
                    end

                    vRP.openMenu({player,menu})
                end})
            end}
        end
        add(choices)
    end
end})
