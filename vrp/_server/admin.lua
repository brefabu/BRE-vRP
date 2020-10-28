-- Admin Menu Options
-- by brefabu

-- registerAdminOption Sys

local options = {}

function vRP.registerAdminOption(name, role, description, callback)
    table.insert(options,{name = name, role = role, description = description, callback = callback})
end

-- Register Options
vRP.registerAdminOption("Tp player", "Helper", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            vRPclient.getPosition(player,{},function(x,y,z)
                local tplayer = vRP.getUserSource(nuser_id)
                if tplayer ~= nil then
                    vRPclient.teleport(tplayer,{x,y,z})
                else
                    vRPclient.notify(player,"Player not online!")
                end
            end)
        else
            vRPclient.notify(player,"Invalid ID!")
        end
    end)
end)

vRP.registerAdminOption("Tp to player", "Helper", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            local tplayer = vRP.getUserSource(nuser_id)
            if tplayer ~= nil then
                vRPclient.getPosition(tplayer,{},function(x,y,z)
                vRPclient.teleport(player,{x,y,z})
                end)
            else
                vRPclient.notify(player,"Player not online!")
            end
        else
            vRPclient.notify(player,"Invalid ID!")
        end
    end)
end)

vRP.registerAdminOption("Tp to waypoint", "Helper", "", function(player)
    vRPclient.teleportToWaypoint(player,{})
end)

vRP.registerAdminOption("Spectate Player", "Helper", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            local nplayer = vRP.getUserSource(nuser_id)
            if nplayer ~= nil then
                TriggerClientEvent("vRP:requestSpectate", player, nplayer)
            else
                vRPclient.notify(player,"Player not online!")
            end
        else
            vRPclient.notify(player,"Invalid ID!")
        end
    end)
end)

vRP.registerAdminOption("Block Player", "Administrator", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            if nuser_id ~= nil then
                vRP.ban(nuser_id,true)
                vRPclient.notify(player,"<span style='color:red'>Playe is blocked! ID: "..nuser_id.."</span>")
            end
        end
    end)
end)

vRP.registerAdminOption("Unblock Player", "Administrator", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            if nuser_id ~= nil then
                vRP.ban(nuser_id,false)
                vRPclient.notify(player,"<span style='color:red'>Playe is unblocked! ID: "..nuser_id.."</span>")
            end
        end
    end)
end)

vRP.registerAdminOption("Kick Player", "Administrator", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            if nuser_id ~= nil then
                vRP.kick(source,"You're kicked right in the ass!")
                vRPclient.notify(player,"<span style='color:red'>Playe is out! ID: "..nuser_id.."</span>")
            end
        end
    end)
end)

vRP.registerAdminOption("Froze Player", "Administrator", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            local tplayer = vRP.getUserSource(nuser_id)

            if tplayer ~= nil then
                vRPclient.toggleFreeze(tplayer,{true})
                vRPclient.notify(player,{"Player is frozen!"})
            else
                vRPclient.notify(player,"Player not online!")
            end
        else
            vRPclient.notify(player,"Invalid ID!")
        end
    end)
end)

vRP.registerAdminOption("Unfroze Player", "Administrator", "", function(player)
    vRP.prompt(player,"Id Jucator: ","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then
            nuser_id = tonumber(nuser_id)
            local tplayer = vRP.getUserSource(nuser_id)

            if tplayer ~= nil then
                vRPclient.toggleFreeze(tplayer,{false})
                vRPclient.notify(player,{"Player is unfrozen!"})
            else
                vRPclient.notify(player,"Player not online!")
            end
        else
            vRPclient.notify(player,"Invalid ID!")
        end
    end)
end)

vRP.registerAdminOption("Coords", "Developer", "", function(player)
    vRPclient.getPosition(player,{},function(x,y,z)
        vRP.prompt(player,"CTRL + A & CTRL + C",x..","..y..","..z,function(player,choice) end)
    end)
end)

vRP.registerAdminOption("Tp to coords", "Developer", "", function(player)
    vRP.prompt(player,"Coords x,y,z:","",function(player,fcoords) 
        local coords = {}
        for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
          table.insert(coords,tonumber(coord))
        end
    
        local x,y,z = 0,0,0
        if coords[1] ~= nil then x = coords[1] end
        if coords[2] ~= nil then y = coords[2] end
        if coords[3] ~= nil then z = coords[3] end
    
        vRPclient.teleport(player,{x,y,z})
    end)
end)
  
  --OWNER
vRP.registerAdminOption("Ofer Money", "Owner", "", function(player)
    local user_id = vRP.getUserId(player)

    vRP.prompt(player,"Amount of money: ","",function(player,amount) 
        if amount ~= nil and amount ~= "" then
            amount = tonumber(amount)

            if amount > 0 and amount < 1000000 then
                vRP.giveMoney(user_id, amount)
                vRPclient.notify(player,{"You offered "..amount.." EURO!"})
            else
                vRPclient.notify(player,"Value not valid!")
            end
        else
            vRPclient.notify(player,"Seriously, nothing?!")
        end
    end)
end)
  
vRP.registerAdminOption("Ofer Item", "Owner", "", function(player)
    local user_id = vRP.getUserId(player)

    vRP.prompt(player,"Item id: ","",function(player,idname) 
        if idname ~= nil and idname ~= "" then
            vRP.prompt(player,"Amount: ","",function(player,amount) 
                if amount ~= nil and amount ~= "" then
                    amount = tonumber(amount)
        
                    if amount > 0 and amount < 100 then
                        vRP.giveMoney(user_id, amount)
                        vRP.giveInventoryItem("player:"..user_id, idname, amount)
                        vRPclient.notify(player,{"You offered "..amount.." "..vRP.getItemName(idname).."!"})
                    else
                        vRPclient.notify(player,"To big number or negative!")
                    end
                else
                    vRPclient.notify(player,"Value not valid!")
                end
            end)
        else
            vRPclient.notify(player,"Seriously, nothing?!")
        end
    end)
end)
  
vRP.registerAdminOption("Noclip", "Owner", "Foloseste Noclip!", function(player)
    local user_id = vRP.getUserId(player)

    vRPclient.toggleNoclip(player)
end)

-- Register Admin Menu

vRP.registerMenuBuilder("main", function(add, data)
    local player = data.player
  
    local user_id = vRP.getUserId(player)
    
    if user_id ~= nil then
        local choices = {}

        if vRP.hasUserRole(user_id, "Helper") then
            choices["Menu Staff"] = {function(player, choice)
                vRP.buildMenu("admin", {player = player}, function(menu)
                    menu.name = "Menu Staff"
                    menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
                    
                    for i,v in pairs(options) do
                        if vRP.hasUserRole(user_id, v.role) then
                            menu[v.name] = {function(player,choice)
                                v.callback(player)
                            end, v.description}
                        end
                    end

                    vRP.openMenu(player,menu)
                end)
            end,"Administration menu!"}
        end

        add(choices)
    end
end)
