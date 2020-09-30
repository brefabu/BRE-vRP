local skins = module("config/skins")
local on_duty = {}

local function build_client_duty(source)
	local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        for i,v in pairs(skins) do
            for j,k in pairs(v._coords) do
                local x,y,z = table.unpack(k)
                local duty_enter = function(player,area)
                    if user_id ~= nil then
                        local skins = false
                        
                        if vRP.isPlayerInFaction(user_id,i) then
                            skins = true
                        end

                        if on_duty[user_id] ~= nil and skins then
                            vRP.buildMenu("skins", {user_id = user_id, player = player}, function(menu)
                                menu.name="Duty"
                                menu.css={top="75px",header_color="rgba(25525,0,0.75)"}

                                menu["On duty"] = {function(player,data)
                                    if vRP.isPlayerInFaction(user_id,i) and on_duty[user_id] == false then
                                        local model = v[vRP.getPlayerRankFaction(user_id)].model
                                        vRPclient.SetPedModel(player,{model})
                                        on_duty[user_id] = true
                                    end
                                end}

                                menu["Off duty"] = {function(player,data)
                                    if on_duty[user_id] == true then
                                        on_duty[user_id] = false
                                        TriggerClientEvent("vRP_C:playerSpawned",player,vRP.users[player].data.customization)
                                        vRPclient.removeAllWeapons(player)             
                                    end
                                end}

                                vRP.openMenu(player,menu)
                            end)
                        end
                    end
                end
                local duty_leave = function(player,area)
                    vRP.closeMenu(player)
                end

                vRPclient.addMarker(source,{x,y,z-0.75,2.0,2.0,0.5, 200, 0, 45, 125, 100})
                vRP.setArea(source,"vRP:skins"..i..j,x,y,z,1,1.5,duty_enter,duty_leave)
            end
        end
    end
end

AddEventHandler("vRP:playerJoinFaction",function(user_id,player,faction)
    on_duty[user_id] = false
    TriggerClientEvent("vRP_C:playerSpawned",player,vRP.users[player].data.customization)  
end)

AddEventHandler("vRP:playerLeaveFaction",function(user_id,player)
    on_duty[user_id] = false
    TriggerClientEvent("vRP_C:playerSpawned",player,vRP.users[player].data.customization)  
end)

-- add choices to the menu
vRP.registerMenuBuilder("interaction", function(add, data)
    local player = data.player
  
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local choices = {}

        choices["Fix Skin"] = {function(player,choice)
            if on_duty[user_id] == false then
                TriggerClientEvent("vRP_C:playerSpawned",player,vRP.users[player].data.customization)
            end
        end}   

        add(choices)
    end
end)  

AddEventHandler("vRP:playerLoggedIn",function(source,user_id)
    if source ~= nil then
        on_duty[user_id] = false
        build_client_duty(source)
    end
end)

