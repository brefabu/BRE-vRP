

vRP.registerCommand("tptome", "Helper", "Helper", "Teleporteaza jucatorul selectat la locatia ta!", function(player,args)
    local nuser_id = tonumber(args[1])

    vRPclient.getPosition(player,{},function(x,y,z)
        local tplayer = vRP.getUserSource(nuser_id)
        if tplayer ~= nil then
        vRPclient.teleport(tplayer,{x,y,z})
        end
    end)
end)

vRP.registerCommand("tpto", "Helper", "Helper", "Teleporteaza-te la locatia jucatorului selectat!", function(player,args)
    local nuser_id = tonumber(args[1])

    local tplayer = vRP.getUserSource(nuser_id)
    if tplayer ~= nil then
        vRPclient.getPosition(tplayer,{},function(x,y,z)
        vRPclient.teleport(player,{x,y,z})
        end)
    end
end)

vRP.registerCommand("tptowaypont", "Helper", "Helper", "Teleporteaza-te la Waypoint!", function(player,args)
    vRPclient.teleportToWaypoint(player,{})
end)

vRP.registerCommand("tpw", "Helper", "Helper", "Teleporteaza-te la Waypoint!", function(player,args)
    vRPclient.teleportToWaypoint(player,{})
end)

vRP.registerCommand("spec", "Helper", "Helper", "Supravegheaza jucatorul selectat!", function(player,args)
    local user_id = vRP.getUserId(player)
    local nuser_id = tonumber(args[1])

    local nplayer = vRP.getUserSource(nuser_id)
    TriggerClientEvent("vRP:requestSpectate", player, nplayer)
end)

--Administrator
vRP.registerCommand("ban", "Administrator", "Administrator", "Interzice jucatorul selectat!", function(player,args)
    local nuser_id = tonumber(args[1])
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        vRP.ban(nuser_id,true)
        TriggerClientEvent('chat:addMessage', player, {template = "<span style='color:red'>[</span> Ai blocat accesul lui {0}! <span style='color:red'>]</span>",args = {vRP.getUserName(vRP.getUserSource(nuser_id)).."["..nuser_id.."]"}})    
    end
end)

vRP.registerCommand("unban", "Administrator", "Administrator", "Scoate interzicerea jucatorului selectat!", function(player,args)
    local nuser_id = tonumber(args[1])
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        vRP.setBanned(nuser_id,false)
        TriggerClientEvent('chat:addMessage', player, {template = "<span style='color:red'>[</span> Ai scos blocarea contului lui {0}! <span style='color:red'>]</span>",args = {vRP.getUserName(vRP.getUserSource(nuser_id)).."["..nuser_id.."]"}})    
    end
end)

vRP.registerCommand("whitelist", "Administrator", "Administrator", "Adauga jucatorul selectat in WHITELIST!", function(player,args)
    local nuser_id = tonumber(args[1])
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        vRP.setWhitelisted(nuser_id,true)
        TriggerClientEvent('chat:addMessage', player, {template = "<span style='color:red'>[</span> Ai oferit acces whitelist lui {0}! <span style='color:red'>]</span>",args = {vRP.getUserName(vRP.getUserSource(nuser_id)).."["..nuser_id.."]"}})    
    end
end)

vRP.registerCommand("unwhitelist", "Administrator", "Administrator", "Scoate jucatorul selectat din WHITELIST!", function(player,args)
    local nuser_id = tonumber(args[1])
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        vRP.setWhitelisted(nuser_id,false)
        TriggerClientEvent('chat:addMessage', player, {template = "<span style='color:red'>[</span> Ai scos accesul whitelist lui {0}! <span style='color:red'>]</span>",args = {vRP.getUserName(vRP.getUserSource(nuser_id)).."["..nuser_id.."]"}})    
    end
end)

vRP.registerCommand("kick", "Administrator", "Administrator", "Da afara jucatorul selectat din sesiune!", function(player,args)
    local nuser_id = tonumber(args[1])
    local reason = args[2]

    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        if source ~= nil then
        vRP.kick(source,reason)
        TriggerClientEvent('chat:addMessage', player, {template = "<span style='color:red'>[</span> L-ai dat afara pe {0}! <span style='color:red'>]</span>",args = {vRP.getUserName(vRP.getUserSource(nuser_id)).."["..nuser_id.."]"}})    
        end
    end
end)

vRP.registerCommand("noclip", "Administrator", "Administrator", "Foloseste modul NoClip!", function(player,args)
    vRPclient.toggleNoclip(player, {})
end)

vRP.registerCommand("freeze", "Administrator", "Administrator", "Ingheata jucatorul selectat!", function(player,args)
    local nuser_id = tonumber(args[1])

    local tplayer = vRP.getUserSource(tonumber(nuser_id))
    if tplayer ~= nil then
        vRPclient.toggleFreeze(tplayer,{true})
        vRPclient.notify(player,{"~r~Jucator a fost inghetat!"})
    end
end)

vRP.registerCommand("unfreeze", "Administrator", "Administrator", "Dezgheata jucatorul selectat!", function(player,args)
    local nuser_id = tonumber(args[1])

    local tplayer = vRP.getUserSource(tonumber(nuser_id))

    if tplayer ~= nil then
        vRPclient.toggleFreeze(tplayer,{false})
        vRPclient.notify(player,{"~r~Jucator a fost dezghetat!"})
    end
end)

--DEVELOPER
vRP.registerCommand("coords", "Developer", "Developer", "Pentru a accesa coordonatele!", function(player,args)
    vRPclient.getPosition(player,{},function(x,y,z)
        vRP.prompt(player,"CTRL + A & CTRL + C",x..","..y..","..z,function(player,choice) end)
    end)
end)

vRP.registerCommand("tptocoords", "Developer", "Developer", "Pentru a te teleporta la coordonatele date!", function(player,args)
    local coords = {
        [1] = args[1],
        [2] = args[2],
        [3] = args[3]
    }

    for i,v in coords do
        
    end

    local x,y,z = 0,0,0
    if coords[1] ~= nil then x = coords[1] end
    if coords[2] ~= nil then y = coords[2] end
    if coords[3] ~= nil then z = coords[3] end

    print(x,y,z)

    vRPclient.teleport(player,{x,y,z})
end)
  
  --OWNER
vRP.registerCommand("givemoney", "Fondator", "Fondator", "Da-ti bani!", function(player,args)
    local amount = tonumber(args[1])
    local user_id = vRP.getUserId(player)

    vRP.giveMoney(user_id, amount)
end)
  
vRP.registerCommand("giveitem", "Fondator", "Fondator", "Da-ti un item!", function(player,args)
    local item = tonumber(args[1])
    local amount = tonumber(args[2])
    local user_id = vRP.getUserId(player)

    vRP.giveInventoryItem("player:"..user_id, idname, amount)
end)
  
--------------------------------------------------------------------------------------------
--COMMANDS
  
RegisterCommand("help",function(source,args)
    local user_id = vRP.getUserId(source)
    local page = tonumber(args[1]) or 1

    local cmds = {}
    local count = 0
    for i,v in pairs(commands) do
        count = count + 1

        if count >= page*4 and count <= (page+1)*4 then
            cmds[i] = v
        end
    end

    TriggerClientEvent("chat:clear", source)
    TriggerClientEvent('chat:addMessage', -1, {template = "Ajutor Comenzi | Foloseste /help [pagina]",args = {}})
    TriggerClientEvent('chat:addMessage', -1, {template = "Sunteti la pagina: "..page.." / ".. tostring(count/4),args = {}})
    
    
    for i,v in pairs(cmds) do
        TriggerClientEvent('chat:addMessage', -1, {template = "[{0}] /{1} - {2}",args = {v.class, i, v.description}})
    end
end)